class SubjectImage < ActiveRecord::Base
  include Apress::Images::Imageable

  acts_as_image(
    attachment_options: {
      styles: {
        big: {
          geometry: '600x600>'
        },
        small: {
          geometry: '50x50>'
        }
      }
    },
    background_processing: false,
    cropable_styles: [:big, :small],
    crop_options: {min_height: 100, min_width: 100}
  )
end
