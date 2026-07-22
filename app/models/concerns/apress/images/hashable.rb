# frozen_string_literal: true

module Apress
  module Images
    # Public: Миксин, содержащий логику, связанную с хэшами изображений
    module Hashable
      extend ActiveSupport::Concern

      included do
        class_attribute :hash_table_name
        class_attribute :hash_external_id

        self.hash_table_name = "#{name.demodulize.underscore}_hashes"
        self.hash_external_id = "#{name.demodulize.underscore}_id"

        after_commit :delete_hash, on: :destroy
      end

      def save_hash
        raise 'Cannot rewrite hash' if hash_exists?

        img_hash = Apress::Images::CalculateHashService.call(self)
        image_hash_storage_connection.execute <<~SQL
          INSERT INTO
            #{self.class.hash_table_name}
              (#{self.class.hash_external_id}, mh_hash_vector_binary, created_at, updated_at)
          VALUES
            (#{id}, '#{img_hash}', NOW(), NOW())
        SQL
      end

      def hash_exists?
        if self.class.include?(::Apress::Images::Deduplicable) && duplicate?
          image_hash_storage_connection.select_one <<~SQL
            SELECT 1 FROM #{self.class.hash_table_name} WHERE #{self.class.hash_external_id} = #{fingerprint_parent_id}
          SQL
        else
          image_hash_storage_connection.select_one <<~SQL
            SELECT 1 FROM #{self.class.hash_table_name} WHERE #{self.class.hash_external_id} = #{id}
          SQL
        end
      end

      private

      def delete_hash
        # Если подключена дедубликация, и если картика дубль или оригинал с дублями,
        # то ничего не делаем
        if self.class.include?(::Apress::Images::Deduplicable)
          return true if duplicate?

          first_duplicate = self.class.where(fingerprint_parent_id: id).first

          return true if first_duplicate
        end

        image_hash_storage_connection.execute <<~SQL
          DELETE FROM #{self.class.hash_table_name} WHERE #{self.class.hash_external_id} = #{id}
        SQL
      end

      def image_hash_storage_connection
        ActiveRecord::Base.on(Rails.application.config.images.fetch(:image_hashes_storage_connection)).connection
      end
    end
  end
end
