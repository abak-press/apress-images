require 'spec_helper'

RSpec.describe Apress::Images::Imageable do
  let(:image) { build :subject_image }
  let(:dummy_filepath) { Rails.root.join('../fixtures/images/sample_image.jpg') }

  before { allow(Apress::Images::ProcessJob).to receive(:enqueue) }

  it { expect(image).to have_attached_file(:img) }
  it { expect(image).to validate_attachment_presence(:img) }
  it { expect(image).to validate_attachment_content_type(:img).allowing('image/png', 'image/gif') }
  it { expect(image).to validate_attachment_content_type(:img).rejecting('text/plain', 'text/xml') }
  it { expect(image).to validate_attachment_size(:img).less_than(image.class.max_size.megabytes) }

  describe '#styles' do
    it { expect(image.styles).to eq image.class.attachment_options[:styles].keys }
  end

  describe 'delegated methods' do
    before { allow_any_instance_of(Paperclip::Attachment).to receive(:path).and_return(dummy_filepath) }

    it 'delegates attachment methods' do
      expect(image.thumbs).to eq(image.img.thumbs)
      expect(image.files).to eq(image.img.files)
      expect(image.fingerprints).to eq(image.img.fingerprints)
      expect(image.most_existing_style).to eq(image.img.most_existing_style)
      expect(image.original_or_biggest_style).to eq(image.img.original_or_biggest_style)
    end
  end

  describe '#normalize_positions' do
    context 'when save' do
      it { expect(image.class).to receive(:normalize_positions) }

      after { image.save! }
    end

    context 'when destroy' do
      let!(:image) { create :subject_image }

      it { expect(image.class).to receive(:normalize_positions) }

      after { image.destroy }
    end
  end

  context 'when model has custom attachment attribute' do
    let(:image) { build :custom_attribute_image, custom: nil }
    let(:attachment) { Rack::Test::UploadedFile.new(Rails.root.join(dummy_filepath), 'image/jpeg') }

    it 'assigns image by default attribute (img)' do
      expect { image.update_attributes!(img: attachment) }.to change { image.custom_file_name }
    end

    it 'assigns image by custom attribute' do
      expect { image.update_attributes!(custom: attachment) }.to change { image.custom_file_name }
    end
  end

  context 'when compressor processor enabled for jpegs' do
    let(:file) { File.open(Rails.root.join('../fixtures/images/sample_image.jpg')) }
    let(:image) { create :compressed_image, img: file }
    let(:image2) { create :uncompressed_image, img: file }

    let!(:compressor_settings) { Rails.application.config.images.fetch(:compressor_options) }

    let(:image_size) { File.size(Rails.root.join('public', image.img.path(:original))) }
    let(:image2_size) { File.size(Rails.root.join('public', image2.img.path(:original))) }

    after do
      Rails.application.config.images[:compressor_options] = compressor_settings
    end

    list = %i[jpegtran jhead jpegoptim jpegrecompress]
    list.each do |compressor|
      context "when used #{compressor}" do
        before do
          Rails.application.config.images[:compressor_options][compressor] = true

          (list - [compressor]).each do |c|
            Rails.application.config.images[:compressor_options][c] = false
          end
        end

        it do
          expect(image_size).to be <= image2_size

          puts "#{compressor}: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
        end
      end
    end

    context 'when allowed lossy' do
      context 'when used jpegoptim' do
        before do
          Rails.application.config.images[:compressor_options][:jpegoptim] = {
            allow_lossy: true,
            strip: :all,
            max_quality: 85
          }

          (list - [:jpegoptim]).each do |c|
            Rails.application.config.images[:compressor_options][c] = false
          end
        end

        it do
          expect(image_size).to be <= image2_size

          puts "jpegoptim with lossy: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
        end
      end

      context 'when used jpegrecompress' do
        before do
          Rails.application.config.images[:compressor_options][:jpegrecompress] = {
            allow_lossy: true,
            quality: 1
          }

          (list - [:jpegrecompress]).each do |c|
            Rails.application.config.images[:compressor_options][c] = false
          end
        end

        it do
          expect(image_size).to be <= image2_size

          puts "jpegrecompress with lossy: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
        end
      end
    end
  end

  context 'when compressor processor enabled for pngs' do
    let(:file) { File.open(Rails.root.join('../fixtures/images/sample_image.png')) }
    let(:image) { create :compressed_image, img: file }
    let(:image2) { create :uncompressed_image, img: file }

    let!(:compressor_settings) { Rails.application.config.images[:compressor_options] }

    let(:image_size) { File.size(Rails.root.join('public', image.img.path(:original))) }
    let(:image2_size) { File.size(Rails.root.join('public', image2.img.path(:original))) }

    after do
      Rails.application.config.images[:compressor_options] = compressor_settings
    end

    list = %i[optipng pngcrush pngquant advpng]
    list.each do |compressor|
      context "when used #{compressor}" do
        before do
          Rails.application.config.images[:compressor_options][compressor] = true

          (list - [compressor]).each do |c|
            Rails.application.config.images[:compressor_options][c] = false
          end
        end

        it do
          expect(image_size).to be <= image2_size

          puts "#{compressor}: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
        end
      end
    end

    context 'when allowed lossy' do
      context 'when used pngquant' do
        before do
          Rails.application.config.images[:compressor_options][:pngquant] = {
            allow_lossy: true,
            quality: 75..90,
            speed: 3
          }

          (list - [:pngquant]).each do |c|
            Rails.application.config.images[:compressor_options][c] = false
          end
        end

        it do
          expect(image_size).to be <= image2_size

          puts "pngquant with lossy: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
        end
      end
    end
  end

  context 'when compressor processor enabled for gifs' do
    let(:file) { File.open(Rails.root.join('../fixtures/images/sample_image.gif')) }
    let(:image) { create :compressed_image, img: file }
    let(:image2) { create :uncompressed_image, img: file }

    let!(:compressor_settings) { Rails.application.config.images[:compressor_options] }

    let(:image_size) { File.size(Rails.root.join('public', image.img.path(:original))) }
    let(:image2_size) { File.size(Rails.root.join('public', image2.img.path(:original))) }

    after do
      Rails.application.config.images[:compressor_options] = compressor_settings
    end

    context "when used gifsicle" do
      before do
        Rails.application.config.images[:compressor_options][:gifsicle] = true

        (
          Rails.application.config.images[:compressor_options].keys - [:gifsicle, :verbose, :skip_missing_workers]
        ).each do |c|
          Rails.application.config.images[:compressor_options][c] = false
        end
      end

      it do
        expect(image_size).to be <= image2_size

        puts "gifsicle: compression is #{((image2_size - image_size) * 100.0 / image2_size).round(2)}%"
      end
    end
  end
end
