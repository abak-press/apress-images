require 'spec_helper'

RSpec.describe Paperclip::Watermark do
  let(:image_file_jpeg) do
    fixture_file_upload(Rails.root.join('../fixtures/images/sample_image.jpg'), 'image/jpeg', :binary)
  end
  let(:image_file_gif) do
    fixture_file_upload(Rails.root.join('../fixtures/images/sample_gif_image.gif'), 'image/gif', :binary)
  end
  let(:watermark_path) { Rails.root.join('../fixtures/images/pcwm_small.png') }
  let(:instance) { described_class }
  let(:types) { 'image/gif' }

  describe '#program' do
    context 'watermark param is present' do
      context 'content_type is image/gif' do
        context 'instance with types_without_watermark param' do
          let(:params) { {watermark_path: watermark_path, types_without_watermark: types} }

          it { expect(instance.new(image_file_gif, params).program).to eq 'convert' }
        end

        context 'instance without types_without_watermark param' do
          let(:params) { {watermark_path: watermark_path} }

          it { expect(instance.new(image_file_gif, params).program).to eq 'composite' }
        end
      end

      context 'content_type is image/jpeg' do
        context 'instance with types_with_watermark param' do
          let(:params) { {watermark_path: watermark_path, types_without_watermark: types} }

          it { expect(instance.new(image_file_jpeg, params).program).to eq 'composite' }
        end

        context 'instance without types_without_watermark param' do
          let(:params) { {watermark_path: watermark_path} }

          it { expect(instance.new(image_file_jpeg, params).program).to eq 'composite' }
        end
      end
    end

    context 'watermark_path param is not present' do
      context 'types_with_watermark param is present' do
        context 'content_type is image/gif' do
          let(:params) { {types_without_watermark: types} }

          it { expect(instance.new(image_file_gif, params).program).to eq 'convert' }
        end

        context 'content_type is image/jpeg' do
          let(:params) { {types_without_watermark: types} }

          it { expect(instance.new(image_file_jpeg, params).program).to eq 'convert' }
        end
      end

      context 'types_with_watermark param is not present' do
        context 'content_type is image/gif' do
          it { expect(instance.new(image_file_gif).program).to eq 'convert' }
        end

        context 'contenxt_type is image/jpeg' do
          it { expect(instance.new(image_file_jpeg).program).to eq 'convert' }
        end
      end
    end

    context 'watermark_path param is nil' do
      context 'types_without_watermark param is present' do
        context 'content_type is image/gif' do
          let(:params) { {watermark_path: nil, types_without_watermark: types} }

          it { expect(instance.new(image_file_gif, params).program).to eq 'convert' }
        end

        context 'content_type is image/jpeg' do
          let(:params) { {watermark_path: nil, types_without_watermark: types} }

          it { expect(instance.new(image_file_jpeg, params).program).to eq 'convert' }
        end
      end

      context 'types_with_watermark params is not present' do
        context 'content_type is image/gif' do
          let(:params) { {watermark_path: nil} }

          it { expect(instance.new(image_file_gif, params).program).to eq 'convert' }
        end

        context 'content_type is image/jpeg' do
          let(:params) { {watermark_path: nil} }

          it { expect(instance.new(image_file_jpeg, params).program).to eq 'convert' }
        end
      end
    end
  end
end
