# coding: utf-8

require 'spec_helper'

RSpec.describe Apress::Images::GarbageCollectorJob do
  describe '.perform' do
    context 'when period has passed less than default value' do
      before { create_list :image, 2, subject_id: nil }
      it { expect { described_class.perform }.to_not change(Apress::Images::Image, :count) }
    end

    context 'when period has passed more than default value' do
      before do
        create_list :image, 2, subject_id: nil
        Timecop.travel (described_class::DEFAULT_PERIOD + 1.minute).from_now
      end

      it { expect { described_class.perform }.to change(Apress::Images::Image, :count).by(-2) }

      after { Timecop.return }
    end
  end
end
