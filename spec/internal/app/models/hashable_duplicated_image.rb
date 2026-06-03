# frozen_string_literal: true

class HashableDuplicatedImage < ActiveRecord::Base
  include Apress::Images::Imageable

  self.table_name = 'hashable_duplicated_images'

  acts_as_image(
    table_name: 'hashable_duplicated_images',
    deduplication: true,
    deduplication_moved_attributes: %w(subject_id subject_type),
    deduplication_copy_attributes: %w(node processing),
    background_processing: false,
    hashable: true
  )
end
