# frozen_string_literal: true

module Apress
  module Images
    class MasterHashingService
      DEFAULT_BATCH_SIZE = 100
      DEFAULT_CHILDREN_COUNT = 4
      private_constant :DEFAULT_BATCH_SIZE, :DEFAULT_CHILDREN_COUNT

      # Public: инициализация сервиса
      #
      # model - Class модель, для которой считаем хэши картинок (например ProductImage)
      # options - Hash:
      #   children_count - сколько запускать дочерних джобов для насчёта хэшей
      #   batch_size - размер пачки для выборки
      #   check_for_existence - проверять есть ли для картинки уже посчитанный хэш
      #   ignore_last_calculated - не смотрим на последний вычисленный хэш и идём с начала
      #   hashes_table - таблица, куда складываем хэши (например product_image_hashes)
      #   hashes_table_external_id - колонка в hashes_table с идами model (например product_image_id)
      #
      # Returns MasterHashingService instance
      def initialize(model, options)
        options = options.symbolize_keys

        @model = model.constantize
        @children_count = options.fetch(:children_count, DEFAULT_CHILDREN_COUNT).to_i
        @batch_size = options.fetch(:batch_size, DEFAULT_BATCH_SIZE).to_i
        @check_for_existence = options.fetch(:check_for_existence, false)
        @ignore_last_calculated = options.fetch(:ignore_last_calculated, false)
        @hashes_table = options[:hashes_table]
        @external_id = options[:hashes_table_external_id]
      end

      def self.call(model, options)
        new(model, options).call
      end

      def call
        info('Start master hashing job')

        # Если есть дочерние джобы и они не завершились, то выходим
        if !no_children? && !all_children_finished?
          info("Children are still running, children status: #{get_children_status}")
          check_errors! # Проверяем, есть ли упавшие дочерние джобы
          return
        end

        # Если нет дочерних джобов, начинаем насчёт хэшей
        if no_children?
          # Достаём ид последней картинки с вычисленным хэшем
          @last_hash_id =
            if @ignore_last_calculated
              0
            else
              image_hash_storage_connection.select_one(<<~SQL).values.first.to_i
                SELECT MAX(#{@external_id})
                FROM #{@hashes_table};
              SQL
            end

          return info('Nothing to calculate') if total_batches_count.zero?

          init_children_status
          async_calculate_hashes
        end

        # Если дочерние джобы завершились, сбрасываем их статусы в редисе
        if all_children_finished?
          reset_children
        end
      rescue StandardError => e
        info("Master hashing job failed: #{e.message}")
        raise
      ensure
        info("Finishing master hashing job, children status: #{get_children_status}")
      end

      private

      def init_children_status
        each_child { |child_num| redis.setex(redis_child_key(child_num), 24.hours, 'init') }
      end

      def get_children_status
        each_child { |child_num| redis.get redis_child_key(child_num) }
      end

      def check_errors!
        return unless children_have_errors?

        raise "Child job failed, check log/images_hashing.log and resque.log for errors"
      end

      def no_children?
        get_children_status.none?
      end

      def all_children_finished?
        get_children_status.all? { |status| status == 'finished' }
      end

      def children_have_errors?
        get_children_status.any? { |status| status == 'failed' }
      end

      def reset_children
        each_child { |child_num| redis.del redis_child_key(child_num) }
      end

      def async_calculate_hashes
        child_options = {
          model: @model.to_s,
          batch_size: @batch_size,
          children_count: @children_count,
          hashes_table: @hashes_table,
          hashes_table_external_id: @external_id
        }
        child_options[:check_for_existence] = @check_for_existence if @check_for_existence

        images_ids.each_with_index do |bucket, job_id|
          ::Apress::Images::ChildHashingJob.
            enqueue(job_id, child_options.merge(bucket: bucket, batches_count: batches_count(job_id)))
        end
      end

      def total_batches_count
        (images_ids.last.last.to_f / @batch_size).ceil
      end

      def batches_count(num)
        ((images_ids[num].last.to_f - images_ids[num].first.to_f) / @batch_size).ceil
      end

      def images_ids
        return @images_ids if defined?(@images_ids)

        @images_ids = ::Apress::Images::ModelRangeDivisionService.new(
          model: @model,
          division_number: @children_count,
          conditions: "id > #{@last_hash_id}"
        ).call
      end

      def redis
        @redis ||= Redis.current
      end

      # Internal: массовые операции в редисе со всеми дочерними джобами
      def each_child
        redis.pipelined do
          @children_count.times.map do |child_num|
            yield child_num
          end
        end
      end

      def redis_key
        @redis_key ||= ['images', 'hash_calc', @model.to_s.underscore.split('/').last].join(':')
      end

      def redis_child_key(index)
        [redis_key, 'job_id', index].join(':')
      end

      def info(message)
        logger&.info("#{@model} #{message}")
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
