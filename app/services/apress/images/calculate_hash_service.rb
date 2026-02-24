# frozen_string_literal: true

require 'phashion'

module Apress
  module Images
    class CalculateHashService
      def self.call(record_or_file)
        new.call(record_or_file)
      end

      def call(record_or_file)
        begin
          hash =
            if record_or_file.respond_to? :img
              tmp = Tempfile.new
              record_or_file.img.copy_to_local_file(:original, tmp.path)
              Phashion::Image.new(tmp.path.to_s).mh_fingerprint
            else
              Phashion::Image.new(record_or_file.path.to_s).mh_fingerprint
            end
        ensure
          tmp.try(:close!)
        end

        # получаем из массива интов строку из битов
        hash.flat_map { |byte| byte.to_s(2).rjust(8, '0').chars }.join
      end
    end
  end
end
