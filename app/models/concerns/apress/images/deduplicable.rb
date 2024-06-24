# frozen_string_literal: true

module Apress
  module Images
    module Deduplicable
      def img=(file)
        raise "Can't change attachment!" if persisted? && img?

        file_fingerprint = fingerprint || Paperclip.io_adapters.for(file).fingerprint
        parent = self.class.find_original(file_fingerprint)

        if parent
          duplicate_from(parent)
          nil
        else
          self.fingerprint ||= file_fingerprint
          super(file)
        end
      end

      def duplicate_from(other_image)
        ((self.class.img_attributes & self.class.column_names) + deduplication_copy_attributes).each do |attribute|
          public_send("#{attribute}=", other_image.public_send(attribute))
        end
        self.fingerprint = other_image.fingerprint
        self.fingerprint_parent_id = other_image.fingerprint_parent_id || other_image.id
      end

      def duplicate?
        fingerprint_parent_id.present?
      end

      def fingerprint_original?
        !duplicate?
      end

      # Public: удаление картинки
      #
      #  В случае если картинка дубль или оригинал, но без дублей - простое удаление.
      #
      #  В случае удаления оргинала, у которого eсть дубли - первый дубль становится оригиналом,
      #  путём копирования важных атрибутов в текущую картинку, а запись с этим дублем удаляется.
      #  Т.о. id оригинала не меняется и остальные дубли обновления не требуют.
      def destroy
        return super if duplicate?

        first_duplicate = self.class.where(fingerprint_parent_id: id).first
        return super unless first_duplicate

        deduplication_moved_attributes.each do |attr|
          public_send("#{attr}=", first_duplicate.public_send(attr))
        end

        first_duplicate.without_kirby_diff_sync = true if first_duplicate.respond_to?(:without_kirby_diff_sync)

        transaction do
          save!
          first_duplicate.destroy
        end

        enqueue_dangling_image if subject_id.nil? && defined?(enqueue_dangling_image)

        # В рельсе 4.2 удаление ассоциации осуществляется через destroy!
        # и он ломается если destroy возвращает nil
        # https://github.com/rails/rails/blob/v4.2.11.3/activerecord/lib/active_record/persistence.rb#L185
        true
      end

      module ClassMethods
        def find_original(file_fingerprint)
          where(fingerprint_parent_id: nil).where(fingerprint: file_fingerprint).first ||
            where(fingerprint_parent_id: nil).where(img_fingerprint: file_fingerprint).first
        end
      end

      module Callbacks
        extend ActiveSupport::Concern

        DUPLICATE_STATUS_JOB_DELAY = 10.minutes

        included do
          after_commit :enqueue_duplicate_updating, on: :create, if: -> { duplicate? && processing? }
          after_commit :dequeue_duplicate_updating, on: :destroy, if: :duplicate?
        end

        def enqueue_duplicate_updating
          Resque.enqueue_in(DUPLICATE_STATUS_JOB_DELAY, Apress::Images::UpdateDuplicateImageJob, id, self.class.name)
        end

        def dequeue_duplicate_updating
          Resque.remove_delayed(Apress::Images::UpdateDuplicateImageJob, id, self.class.name)
        end
      end
    end
  end
end
