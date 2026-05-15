# frozen_string_literal: true

module Apress
  module Images
    class ChildHashingJob
      include ::Resque::Integration

      queue :image_hashing
      unique { |job_num, options| [job_num, options['model']] }

      class << self
        def execute(job_num, options)
          ::Apress::Images::ChildHashingService.call(job_num, options)
        end
      end
    end
  end
end
