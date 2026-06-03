# frozen_string_literal: true

class HashableImage < ActiveRecord::Base
  include Apress::Images::Imageable

  self.table_name = 'hashable_images'

  acts_as_image(
    table_name: 'hashable_images',
    background_processing: false,
    hashable: true
  )
end
