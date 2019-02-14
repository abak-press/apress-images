require 'image_optim'

module Paperclip
  class Compressor < Thumbnail
    def make
      src_path = File.expand_path(super.path)

      if settings[:verbose]
        ::Paperclip.logger.info "optimizing #{src_path} with settings: #{settings.inspect}"
      end

      compressor = ::ImageOptim.new(settings)
      compressed_file_path = compressor.optimize_image(src_path)

      if compressed_file_path && ::File.file?(compressed_file_path.to_s)
        return File.open(compressed_file_path.to_s)
      else
        dst = Tempfile.new([@basename, @format].compact.join('.'))
        dst.binmode
        FileUtils.cp(src_path, File.expand_path(dst.path))

        return dst
      end
    end

    private

    def settings
      @settings ||= ::Rails.application.config.images.fetch(:compressor_options)
    end
  end
end
