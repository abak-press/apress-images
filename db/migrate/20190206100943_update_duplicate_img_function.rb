# frozen_string_literal: true

class UpdateDuplicateImgFunction < ActiveRecord::Migration
  def change
    file_name = ::Apress::Images::Engine.root.join('db/schema/public/image_update_img_from_parent.sql')
    execute File.read(file_name) if File.exist?(file_name)
  end
end
