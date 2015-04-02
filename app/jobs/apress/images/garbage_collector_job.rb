# coding: utf-8

module Apress
  module Images
    # Public: Чистит от "мусорных" картинок
    class GarbageCollectorJob
      # Public: период устаревания картинки
      DEFAULT_PERIOD = 30.minutes

      # Public: Очищает от мусора
      #
      # period - Fixnum, период устаревания картинки с которого можно удалить ее в секундах
      # batch_size - Fixnum, размер пачки
      #
      # Returns nothing
      def self.perform(period = DEFAULT_PERIOD, batch_size = 5_000)
        image_ids = []
        scope = Apress::Images::Image.where(subject_id: nil).where('created_at < ?', period.ago.utc)

        scope.find_each(batch_size: batch_size) do |image|
          image.img.clear
          image.img.flush_deletes
          image_ids << image.id
        end

        image_ids.in_groups(batch_size, false) { |group_ids| scope.klass.delete_all(id: group_ids) }
      end
    end
  end
end
