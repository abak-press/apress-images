# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apress::Images::ChildHashingJob do
  def storage_con
    ActiveRecord::Base.on('image_hashes_storage').connection
  end

  let(:logger) { double('Logger', info: nil) }
  let!(:images) { create_list :subject_image, 3 }

  before do
    allow_any_instance_of(::Apress::Images::ChildHashingService).to receive(:logger).and_return(logger)
  end

  after do
    storage_con.execute('TRUNCATE subject_image_hashes')
  end

  subject do
    described_class.execute(
      0,
      model: 'SubjectImage',
      bucket: [images.first.id, images.last.id],
      batches_count: 1,
      batch_size: 10,
      children_count: 4,
      hashes_table: 'subject_image_hashes',
      hashes_table_external_id: 'subject_image_id'
    )
  end

  context 'when started without master' do
    it do
      expect(logger).to receive(:info).with('SubjectImage Job id 0 Child started without master, exiting...')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 Exiting child hashing job')

      expect(::Apress::Images::MasterHashingJob).to receive(:enqueue)

      subject

      expect(Redis.current.get 'images:hash_calc:subject_image:job_id:0').to be_nil

      expect(storage_con.select_one('select count(*) from subject_image_hashes').values.first.to_i).to eq 0
    end
  end

  context 'when status was initialized' do
    before do
      Redis.current.set('images:hash_calc:subject_image:job_id:0', 'init')
    end

    it do
      expect(logger).to receive(:info).with('SubjectImage Job id 0 working')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 finished')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 Exiting child hashing job')

      expect(::Apress::Images::MasterHashingJob).to receive :enqueue

      subject

      expect(Redis.current.get 'images:hash_calc:subject_image:job_id:0').to eq 'finished'

      expect(storage_con.select_one('select count(*) from subject_image_hashes').values.first.to_i).to eq 3
      expect(storage_con.select_values('select subject_image_id from subject_image_hashes').map(&:to_i)).
        to match_array(images.map(&:id))
      expect(storage_con.select_values('select mh_hash_vector_binary from subject_image_hashes').map(&:size)).
        to eq [576, 576, 576]
    end
  end

  context 'when error occurred outside of pHashion' do
    before do
      Redis.current.set('images:hash_calc:subject_image:job_id:0', 'init')

      allow_any_instance_of(::Apress::Images::ChildHashingService).to receive(:calculate_hashes).and_raise 'Boom!'
    end

    it do
      expect(logger).to receive(:info).with('SubjectImage Job id 0 working')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 failed')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 error: Boom!')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 Exiting child hashing job')

      expect(::Apress::Images::MasterHashingJob).to receive(:enqueue)

      expect { subject }.to raise_error(RuntimeError, 'Boom!')

      expect(Redis.current.get 'images:hash_calc:subject_image:job_id:0').to eq 'failed'
      expect(storage_con.select_one('select count(*) from subject_image_hashes').values.first.to_i).to eq 0
    end
  end

  context 'when corrupted image' do
    let(:corrupted_img_file) do
      fixture_file_upload(Rails.root.join('../fixtures/images/corrupted_image.jpg'), 'image/jpg', :binary)
    end
    let(:corrupted_image) { build :subject_image, img: corrupted_img_file }

    let(:failed_ids) do
      CSV.read(
        Rails.root.join('log', 'images_hashing_failed_ids_0.csv'),
        col_sep: ';'
      ).to_a.flatten.map(&:to_i)
    end

    before do
      corrupted_image.save(validate: false)
      images << corrupted_image
      Redis.current.set('images:hash_calc:subject_image:job_id:0', 'init')
    end

    it do
      expect(logger).to receive(:info).with('SubjectImage Job id 0 working')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 finished')
      expect(logger).to receive(:info).with('SubjectImage Job id 0 Exiting child hashing job')

      expect(::Apress::Images::MasterHashingJob).to receive :enqueue

      subject

      expect(Redis.current.get 'images:hash_calc:subject_image:job_id:0').to eq 'finished'
      expect(storage_con.select_one('select count(*) from subject_image_hashes').values.first.to_i).to eq 3
      expect(storage_con.select_values('select subject_image_id from subject_image_hashes').map(&:to_i)).
        to match_array(images.map(&:id) - [corrupted_image.id])
      expect(storage_con.select_values('select mh_hash_vector_binary from subject_image_hashes').map(&:size)).
        to eq [576, 576, 576]
      expect(failed_ids).to eq [corrupted_image.id]
    end
  end
end
