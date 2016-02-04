# coding: utf-8
require 'spec_helper'

RSpec.describe Subject, type: :model do
  let(:subject) { create :subject }

  it { expect(subject).to have_one(:cover).class_name('SubjectImage') }
  it { expect(described_class.reflect_on_association(:cover).options[:as]).to eq(:subject) }
  it { expect(subject).to accept_nested_attributes_for(:cover).allow_destroy(true) }

  context 'when initializing and saving subject with image assigned through nested attributes' do
    let(:image) { create :subject_image }
    let(:subject) { Subject.new(attributes_for(:subject).merge(cover_attributes: {'id' => image.id})) }

    before { subject.save }

    it do
      expect(subject).to be_persisted
      expect(subject.cover).to be_persisted
      expect(subject.cover).to eq(image)
    end
  end

  context 'when subject exists' do
    context 'when updating subject with image through nested attributes' do
      let(:subject) { create :subject }
      let(:image) { create :subject_image, subject_id: subject.id, subject_type: subject.class.name }

      before do
        subject.assign_attributes(cover_attributes: {'id' => image.id})
        subject.save
      end

      it do
        expect(subject).to be_persisted
        expect(subject.cover).to be_persisted
        expect(subject.cover).to eq(image)
      end
    end

    context 'when subject has cover' do
      context 'when update without cover' do
        let(:subject) { create :subject_with_cover }

        before do
          subject.assign_attributes(subject.attributes)
          subject.save
        end

        it { expect(subject.persisted?).to be_truthy }
        it { expect(subject.cover.persisted?).to be_truthy }
      end

      context 'when update with new cover' do
        let(:subject) { create :subject_with_cover }
        let(:new_image) do
          cover = subject.cover
          cover.img = Rack::Test::UploadedFile.new(Rails.root.join('../fixtures/images/sample_image.jpg'), 'image/jpeg')
          cover.save
          cover
        end

        before do
          subject.assign_attributes(cover_attributes: {'id' => new_image.id})
          subject.save
        end

        it { expect(subject.persisted?).to be_truthy }
        it { expect(subject.cover.persisted?).to be_truthy }
        it { expect(subject.cover).to eq new_image }
      end
    end
  end
end
