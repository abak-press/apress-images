# frozen_string_literal: true

class DropDuplicateImgFunction < ActiveRecord::Migration
  def up
    execute "DROP FUNCTION IF EXISTS image_update_img_from_parent();"
  end
end
