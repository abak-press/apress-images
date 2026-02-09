# frozen_string_literal: true

require 'phashion'

module Apress
  module Images
    class CalculateHashService
      def self.call(record)
        new.call(record)
      end

      def call(record)
        begin
          tmp = Tempfile.new
          record.img.copy_to_local_file(:original, tmp.path)

          hash = Phashion::Image.new(tmp.path.to_s).mh_fingerprint
        ensure
          tmp.close! if tmp && tmp.respond_to?(:close!)
        end

        # получаем из массива интов строку из битов
        hash.flat_map { |byte| byte.to_s(2).rjust(8, '0').chars }.join
      end
    end
  end
end
