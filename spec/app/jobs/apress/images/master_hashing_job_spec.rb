# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Apress::Images::MasterHashingJob do
  def storage_con
    ActiveRecord::Base.on('image_hashes_storage').connection
  end

  let(:logger) { double('Logger', info: nil) }

  before do
    allow_any_instance_of(::Apress::Images::MasterHashingService).to receive(:logger).and_return(logger)
  end

  let(:default_options) do
    {
      hashes_table: 'subject_image_hashes',
      hashes_table_external_id: 'subject_image_id'
    }
  end
  let(:options) { default_options }

  subject do
    described_class.execute('SubjectImage', options)
  end

  describe '.execute' do
    let!(:images) { create_list :subject_image, 8 }

    context 'first run' do
      it 'enqueues child jobs' do
        expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
        expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
          0,
          batch_size: 100,
          batches_count: 1,
          bucket: [images[0].id, images[1].id],
          children_count: 4,
          hashes_table_external_id: 'subject_image_id',
          hashes_table: 'subject_image_hashes',
          model: 'SubjectImage'
        )
        expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
          1,
          batch_size: 100,
          batches_count: 1,
          bucket: [images[2].id, images[3].id],
          children_count: 4,
          hashes_table_external_id: 'subject_image_id',
          hashes_table: 'subject_image_hashes',
          model: 'SubjectImage'
        )
        expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
          2,
          batch_size: 100,
          batches_count: 1,
          bucket: [images[4].id, images[5].id],
          children_count: 4,
          hashes_table_external_id: 'subject_image_id',
          hashes_table: 'subject_image_hashes',
          model: 'SubjectImage'
        )
        expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
          3,
          batch_size: 100,
          batches_count: 1,
          bucket: [images[6].id, images[7].id],
          children_count: 4,
          hashes_table_external_id: 'subject_image_id',
          hashes_table: 'subject_image_hashes',
          model: 'SubjectImage'
        )
        expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                              'children status: ["init", "init", "init", "init"]')

        subject
      end
    end

    context 'when some hashes were already calculated' do
      before do
        storage_con.execute <<~SQL
          INSERT INTO
            subject_image_hashes (subject_image_id)
          VALUES
            (#{images[0].id}), (#{images[1].id})
        SQL
      end

      after do
        storage_con.execute('TRUNCATE subject_image_hashes')
      end

      context 'default behavior' do
        it 'enqueues child jobs without calculated images' do
          expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            0,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[2].id, images[3].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            1,
            batch_size: 100,
            batches_count: 0,
            bucket: [images[4].id, images[4].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            2,
            batch_size: 100,
            batches_count: 0,
            bucket: [images[5].id, images[5].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            3,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[6].id, images[7].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                                'children status: ["init", "init", "init", "init"]')

          subject
        end
      end

      context 'when ignore_last_calculated is set to true' do
        let(:options) { default_options.merge(ignore_last_calculated: true) }

        it 'enqueues child jobs with all images' do
          expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            0,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[0].id, images[1].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            1,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[2].id, images[3].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            2,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[4].id, images[5].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(::Apress::Images::ChildHashingJob).to receive(:enqueue).with(
            3,
            batch_size: 100,
            batches_count: 1,
            bucket: [images[6].id, images[7].id],
            children_count: 4,
            hashes_table_external_id: 'subject_image_id',
            hashes_table: 'subject_image_hashes',
            model: 'SubjectImage'
          )
          expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                                'children status: ["init", "init", "init", "init"]')

          subject
        end
      end
    end

    context 'when children are working' do
      before do
        Redis.current.set('images:hash_calc:subject_image:job_id:0', 'working')
        Redis.current.set('images:hash_calc:subject_image:job_id:1', 'working')
        Redis.current.set('images:hash_calc:subject_image:job_id:2', 'finished')
        Redis.current.set('images:hash_calc:subject_image:job_id:3', 'init')
      end

      it do
        expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
        expect(::Apress::Images::ChildHashingJob).not_to receive(:enqueue)
        expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                              'children status: ["working", "working", "finished", "init"]')

        subject
      end
    end

    context 'when child failed' do
      before do
        Redis.current.set('images:hash_calc:subject_image:job_id:0', 'working')
        Redis.current.set('images:hash_calc:subject_image:job_id:1', 'working')
        Redis.current.set('images:hash_calc:subject_image:job_id:2', 'failed')
        Redis.current.set('images:hash_calc:subject_image:job_id:3', 'init')
      end

      it do
        expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
        expect(::Apress::Images::ChildHashingJob).not_to receive(:enqueue)
        expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                              'children status: ["working", "working", "failed", "init"]')

        expect { subject }.
          to raise_error(RuntimeError, 'Child job failed, check log/images_hashing.log and resque.log for errors')
      end
    end

    context 'when all children finished' do
      before do
        Redis.current.set('images:hash_calc:subject_image:job_id:0', 'finished')
        Redis.current.set('images:hash_calc:subject_image:job_id:1', 'finished')
        Redis.current.set('images:hash_calc:subject_image:job_id:2', 'finished')
        Redis.current.set('images:hash_calc:subject_image:job_id:3', 'finished')
      end

      it do
        expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
        expect(::Apress::Images::ChildHashingJob).not_to receive(:enqueue)
        expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                              'children status: [nil, nil, nil, nil]')

        subject
      end
    end

    context 'when nothing to calculate' do
      before { SubjectImage.destroy_all }

      it do
        expect(logger).to receive(:info).with('SubjectImage Start master hashing job')
        expect(logger).to receive(:info).with('SubjectImage Nothing to calculate')
        expect(::Apress::Images::ChildHashingJob).not_to receive(:enqueue)
        expect(logger).to receive(:info).with('SubjectImage Finishing master hashing job, '\
                                              'children status: [nil, nil, nil, nil]')

        subject
      end
    end
  end
end
