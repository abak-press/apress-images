# frozen_string_literal: true

require 'spec_helper'

describe Apress::Images::Hashable do
  def storage_con
    ActiveRecord::Base.on('image_hashes_storage').connection
  end

  after do
    FileUtils.rm_rf(Rails.root.join('../internal/public/system/images/hashable_images'))
    FileUtils.rm_rf(Rails.root.join('../internal/public/system/images/hashable_duplicated_images'))

    storage_con.execute("TRUNCATE hashable_image_hashes")
    storage_con.execute("TRUNCATE hashable_duplicated_image_hashes")
  end

  describe 'callbacks' do
    context 'delete hash after commit on destroy' do
      context 'when simple hashable image' do
        let!(:image1) { create :hashable_image }
        let!(:image2) { create :hashable_image }

        before do
          image1.save_hash
          image2.save_hash
        end

        it 'deletes hash' do
          expect(storage_con.select_values('select hashable_image_id from hashable_image_hashes').map(&:to_i)).
            to match_array([image1.id, image2.id])

          image1.destroy

          expect(storage_con.select_values('select hashable_image_id from hashable_image_hashes').map(&:to_i)).
            to eq([image2.id])
        end
      end

      context 'when deduplicated hashable image' do
        let!(:original) { create :hashable_duplicated_image }
        let!(:copy) { create :hashable_duplicated_image }

        before do
          original.save_hash
        end

        context 'when destroy copy image' do
          it 'does not delete hash' do
            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])

            copy.destroy

            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])
          end
        end

        context 'when destroy original image' do
          it 'does not delete hash' do
            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])

            original.destroy

            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])
          end
        end

        context 'when destroy copy and original' do
          it 'deletes hash' do
            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])

            copy.destroy
            original.destroy

            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([])
          end
        end

        context 'when destroy original and copy' do
          it 'deletes hash' do
            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([original.id])

            # при удалении оригинала, в него копируются атрибуты из первого дубля и не меняется id,
            # поэтому как-бы удаляем два раза оригинал чтобе удалить обе картинки
            original.destroy
            original.destroy

            expect(
              storage_con.
                select_values('select hashable_duplicated_image_id from hashable_duplicated_image_hashes').
                map(&:to_i)
            ).to eq([])
          end
        end
      end
    end
  end
end
