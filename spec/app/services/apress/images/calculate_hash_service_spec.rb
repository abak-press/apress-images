# frozen_string_literal: true

require 'spec_helper'

describe Apress::Images::CalculateHashService do
  def h_distance(x, y)
    (0..x.size-1).reduce(0) do |sum, i|
      sum + ((x[i] != y[i]) ? 1 : 0)
    end
  end

  describe '.call' do
    let(:expected_hash) do
      '10001000110011100101101010100010'\
      '10110101101011111000011001110010'\
      '00000110010101110110011001011101'\
      '01001110011001000111110100111000'\
      '11100111001110011011010101000111'\
      '01110010001101110001100110011110'\
      '11100111100110000111110010101011'\
      '10100011011111110111110110011100'\
      '11101111001000111001110100110110'\
      '01111110101010110101001100100001'\
      '00010111011100011110011110110001'\
      '00110101010010001010001000100111'\
      '00011010010010001000101110101001'\
      '00010000110001001011100110111001'\
      '10101010011011011101101010011110'\
      '11101101110101001100010001000110'\
      '10110011011100101010100111011011'\
      '10001000101110110111010011101010'
    end

    subject { described_class.call(image) }

    context 'when file' do
      context 'when jpg' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.jpg') }
        let(:image) do
          fixture_file_upload(filepath, 'image/jpeg', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end

      context 'when webp' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.webp') }
        let(:image) do
          fixture_file_upload(filepath, 'image/webp', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to eq 0
        end
      end

      context 'when png' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.png') }
        let(:image) do
          fixture_file_upload(filepath, 'image/png', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end

      context 'when gif' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.gif') }
        let(:image) do
          fixture_file_upload(filepath, 'image/gif', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end
    end

    context 'when db record' do
      let(:image) do
        create :subject_image, img: img
      end

      context 'when jpg' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.jpg') }
        let(:img) do
          fixture_file_upload(filepath, 'image/jpeg', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end

      context 'when webp' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.webp') }
        let(:img) do
          fixture_file_upload(filepath, 'image/webp', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end

      context 'when png' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.png') }
        let(:img) do
          fixture_file_upload(filepath, 'image/png', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end

      context 'when gif' do
        let(:filepath) { Rails.root.join('../fixtures/images/hash_test/sample1.gif') }
        let(:img) do
          fixture_file_upload(filepath, 'image/gif', :binary)
        end

        it do
          expect(h_distance(subject, expected_hash)).to be <= 40
        end
      end
    end
  end
end
