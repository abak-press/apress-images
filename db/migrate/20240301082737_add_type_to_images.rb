# frozen_string_literal: true

class AddTypeToImages < ActiveRecord::Migration
  def up
    # Проверяем, есть ли уже колонка :type
    return if column_exists?(:images, :type)

    add_column :images, :type, :string, comment: 'Название класса модели изображения'

    execute 'END;'
    execute 'ALTER TABLE images DROP CONSTRAINT images_subject_position;'
    execute 'DROP INDEX CONCURRENTLY IF EXISTS idx_images_on_subject_position;'
    execute <<-SQL.strip_heredoc
      CREATE UNIQUE INDEX CONCURRENTLY idx_images_on_subject_type_position
        ON images (subject_id, subject_type, type, position);
    SQL
  end

  def down
    # Проверяем, есть ли уже колонка :type
    return unless column_exists?(:images, :type)

    execute 'END;'
    execute <<-SQL.strip_heredoc
      CREATE UNIQUE INDEX CONCURRENTLY idx_images_on_subject_position
        ON images (subject_type, subject_id, position);
    SQL
    execute <<-SQL.strip_heredoc
      ALTER TABLE images ADD CONSTRAINT images_subject_position
        UNIQUE USING INDEX idx_images_on_subject_position DEFERRABLE INITIALLY DEFERRED;
    SQL

    remove_column :images, :type
  end
end
