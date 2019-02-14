class UncompressedImage < ActiveRecord::Base
  include Apress::Images::Imageable

  acts_as_image(
    background_processing: false,
    attachment_options: {
      styles: {
        big: {
          geometry: '600x600>'
        }
      }
    },
    convert_options: {big: '-strip'}
  )
end
