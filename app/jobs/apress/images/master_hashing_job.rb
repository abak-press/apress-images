# frozen_string_literal: true

module Apress
  module Images
    class MasterHashingJob
      include ::Resque::Integration

      queue :image_hashing
      unique { |model, _options| model }

      class << self
        def execute(model, options)
          ::Apress::Images::MasterHashingService.call(model, options)
        end
      end
    end
  end
end
