# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apress::Images::UpdateDuplicateImageJob do
  let!(:image1) { create :default_duplicated_image }

  let(:image2) do
    image = build :default_duplicated_image
    image1.img.process_delayed!

    image.save!
    image
  end

  describe '.execute' do
    it do
      expect(image2.reload.processing).to be_truthy

      described_class.execute(image2.id, image2.class.to_s)

      expect(image2.reload.processing).to be_falsey
      expect(image2.fingerprint).to eq image1.fingerprint
      expect(image2.img_fingerprint).to eq image1.img_fingerprint
      expect(image2.img_file_name).to eq image1.img_file_name
      expect(image2.img_content_type).to eq image1.img_content_type
      expect(image2.img_file_size).to eq image1.img_file_size
      expect(image2.fingerprint_parent_id).to eq image1.id
    end
  end
end
