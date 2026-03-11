# frozen_string_literal: true

require 'csv'

module Apress
  module Images
    class ChildHashingService
      def initialize(job_num, options)
        options = options.symbolize_keys

        @job_num = Integer(job_num)
        @model = options[:model].constantize
        @bucket = options[:bucket]
        @batches_count = options[:batches_count].to_i
        @batch_size = options[:batch_size].to_i
        @children_count = options[:children_count]
        @hashes_table = options[:hashes_table]
        @external_id = options[:hashes_table_external_id]

        @failed_ids = []

        @current_batch = 0
      end

      def self.call(job_num, options)
        new(job_num, options).call
      end

      def call
        # Если в редисе нет статуса, значит что-то не так
        return info('Child started without master, exiting...') unless initialized?

        working!
        calculate_hashes(*@bucket)
      rescue StandardError => e
        failed!
        info("error: #{e.message}")

        raise
      ensure
        log_failed_ids

        info('Exiting child hashing job')

        # Если дочерний джоб закончил работу или упал,
        # ставим мастер-джоб, который проверит статусы всех дочерних джобов
        ::Apress::Images::MasterHashingJob.enqueue(
          @model.to_s,
          children_count: @children_count,
          batch_size: @batch_size,
          hashes_table: @hashes_table,
          hashes_table_external_id: @external_id
        )
      end

      private

      def calculate_hashes(min_id, max_id)
        current_batch_size = @batch_size

        while min_id <= max_id
          next_id = [min_id + current_batch_size, max_id].min

          data = []

          @model.where('id >= ? AND id <= ?', min_id, next_id).each do |image|
            begin
              mh_hash = ::Apress::Images::CalculateHashService.call(image)
            rescue StandardError => e
              info("error: image id #{image.id} - #{e.message}")
              @failed_ids << image.id

              next
            end

            data << [image.id, mh_hash]
          end

          if data.empty?
            info("Empty batch #{min_id}..#{next_id}")
            next
          end

          image_hash_storage_connection.execute <<~SQL
            INSERT INTO
              #{@hashes_table} (#{@external_id}, mh_hash_vector_binary, created_at, updated_at)
            VALUES
              #{data.map! { |value| "(#{value.first}, '#{value.last}', NOW(), NOW())" }.join(', ')}
          SQL

          min_id = next_id + 1
          log_batch
        end

        finished!
      end

      def log_batch
        @current_batch += 1

        return if !logger || !need_log_batch?

        info("#{progress_percent}% calculated")
      end

      def need_log_batch?
        @current_batch > 0 && @current_batch % 1_000 == 0
      end

      def progress_percent
        return 100 if @batches_count.zero?

        (@current_batch * 100.0 / @batches_count).ceil
      end

      def log_failed_ids
        return if @failed_ids.empty?

        info('Logging failed ids')

        csv_path = Rails.root.join('log', "images_hashing_failed_ids_#{@job_num}.csv")
        ::CSV.open(csv_path, 'w', col_sep: ';') do |row|
          row << @failed_ids
        end
      end

      def initialized?
        redis.get(redis_key) == 'init'
      end

      def working!
        set_status('working')
      end

      def finished!
        set_status('finished')
      end

      def failed!
        set_status('failed')
      end

      def set_status(status)
        info(status)
        redis.setex(redis_key, 72.hours, status)
      end

      def redis
        @redis ||= Redis.current
      end

      def redis_key
        @redis_key ||= ['images', 'hash_calc', @model.to_s.underscore.split('/').last, 'job_id', @job_num].join(':')
      end

      def info(message)
        logger&.info("#{@model} Job id #{@job_num} #{message}")
      end

      def logger
        Rails.application.config.images.fetch(:hashing_logger)
      end

      def image_hash_storage_connection
        ActiveRecord::Base.on(Rails.application.config.images.fetch(:image_hashes_storage_connection)).connection
      end
    end
  end
end
