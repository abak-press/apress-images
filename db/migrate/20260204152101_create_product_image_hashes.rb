# frozen_string_literal: true

class CreateProductImageHashes < ActiveRecord::Migration
  def up
    return if Rails.env.staging?

    conn.enable_extension 'vector'

    conn.create_table :product_image_hashes do |t|
      t.column :product_image_id, :integer, null: false
      t.column :mh_hash_vector_binary, :bit, limit: 576

      t.timestamps
    end

    conn.add_index :product_image_hashes, :product_image_id, unique: true
    conn.execute 'CREATE INDEX ON product_image_hashes USING hnsw (mh_hash_vector_binary bit_hamming_ops);'
  end

  def down
    return if Rails.env.staging?

    conn.drop_table :product_image_hashes
  end

  private

  def conn
    ActiveRecord::Base.on(Rails.application.config.images.fetch(:image_hashes_storage_connection)).connection
  end
end
