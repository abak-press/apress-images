ActiveRecord::Schema.define do
  create_table(:subjects, force: true)

  create_table :delayed_images, force: true do |t|
    t.references :subject, polymorphic: true
    t.string :img_file_name
    t.string :img_content_type
    t.integer :img_file_size
    t.integer :position, null: false, default: 0
    t.boolean :processing, null: false, default: false
    t.timestamps
  end

  create_table :disordered_images, force: true do |t|
    t.references :subject, polymorphic: true
    t.string :img_file_name
    t.string :img_content_type
    t.integer :img_file_size
  end

  create_table :custom_attribute_images, force: true do |t|
    t.references :subject, polymorphic: true
    t.string :custom_file_name
    t.string :custom_content_type
    t.integer :custom_file_size
  end

  create_table :duplicated_images, force: true do |t|
    t.references :subject, polymorphic: true
    t.string :img_file_name
    t.string :img_content_type
    t.string :fingerprint
    t.string :img_fingerprint
    t.integer :fingerprint_parent_id
    t.integer :img_file_size
    t.integer :position, null: false, default: 0
    t.integer :node, null: false, default: 0
    t.boolean :processing, null: false, default: false
    t.timestamp :created_at
    t.timestamp :img_updated_at
  end
end
