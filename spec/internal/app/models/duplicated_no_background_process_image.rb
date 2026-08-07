# frozen_string_literal: true

class DuplicatedNoBackgroundProcessImage < ActiveRecord::Base
  include Apress::Images::Imageable

  self.table_name = 'duplicated_no_background_process_images'

  acts_as_image(
    table_name: 'duplicated_no_background_process_images',
    deduplication: true,
    deduplication_copy_attributes: %w(position)
  )
end
