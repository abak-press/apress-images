# frozen_string_literal: true

module Apress
  module Images
    module OnlineProcessable
      extend ActiveSupport::Concern

      included do
        # Public: Определяет какая обработка изображения будет: онлайн(по умолчанию) или не онлайн
        attr_writer :online_processing
      end

      def online_processing?
        if defined?(@online_processing)
          @online_processing
        else
          true
        end
      end
    end
  end
end

