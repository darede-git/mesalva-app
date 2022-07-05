# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

describe MeSalva::StudyPlan::Answers do
  include StudyPlanHelper

  include_context 'study plan form'

  let(:subject_ids) do
    [1, 2, 3, 4, 5]
  end
  let(:shifts) do
    [{ 1 => :mid },
     { 2 => :morning },
     { 2 => :mid },
     { 2 => :evening },
     { 3 => :mid },
     { 3 => :evening },
     { 4 => :morning },
     { 5 => :mid },
     { 5 => :evening }]
  end
  let(:end_date) { (Time.now + 5.weeks).to_date.to_s }
  let(:keep) { true }

  subject do
    MeSalva::StudyPlan::Answers.new(subject_ids: subject_ids,
                                    shifts: shifts,
                                    end_date: end_date,
                                    keep_completed_modules: keep)
  end

  describe '#valid?' do
    context 'one answer is not present' do
      it 'returns false' do
        expect(missing_answers.valid?).to be_falsey
      end
    end

    context 'when all answers are present' do
      it 'returns true' do
        expect(subject.valid?).to be_truthy
      end
    end
  end

  describe '#errors' do
    context 'an answer is not present or empty' do
      it 'returns a message for the missing answer' do
        answers = missing_answers
        answers.valid?

        expect(missing_answers.errors)
          .to eq(['Answer subject_ids is not present',
                  'Answer end_date is not present'])
      end
    end

    context 'when all answers are present' do
      it 'returns an empty message' do
        expect(subject.errors).to be_empty
      end
    end
  end

  describe '#available_time' do
    context 'invalid answers' do
      it 'returns 0' do
        expect(missing_answers.available_time).to eq(0)
      end
    end
    context 'valid answers' do
      before do
        Timecop.freeze("2019-02-27 11:51:47 -0300")
      end

      it 'returns the available time' do
        expect(subject.available_time).to eq(125)
      end

      context 'only sunday shifts, no first day' do
        it 'returns the correct available time' do
          sunday_shifts = [{ 0 => :morning },
                           { 0 => :mid },
                           { 0 => :evening }]
          answ = MeSalva::StudyPlan::Answers.new(subject_ids: subject_ids,
                                                 shifts: sunday_shifts,
                                                 end_date: end_date,
                                                 keep_completed_modules: keep)

          expect(answ.available_time).to eq(40)
        end
      end

      context 'starting day does not have all shifts' do
        it 'returns the correct available time' do
          friday_shifts = [{ 5 => :morning }]

          answ = MeSalva::StudyPlan::Answers.new(subject_ids: subject_ids,
                                                 shifts: friday_shifts,
                                                 end_date: end_date,
                                                 keep_completed_modules: keep)

          expect(answ.available_time).to eq(15)
        end
      end
    end
  end

  describe '#subject_ids' do
    context 'invalid answers' do
      it 'returns an empty array' do
        expect(missing_answers.subject_ids).to eq([])
      end
    end
    context 'valid answers' do
      it 'returns a list of subjects' do
        expect(subject.subject_ids).to eq([1, 2, 3, 4, 5])
      end
    end
  end

  describe '#keep_completed_modules?' do
    context 'invalid answers' do
      it 'returns an empty array' do
        expect(missing_answers.keep_completed_modules?).to be_falsey
      end
    end
    context 'valid answers' do
      it 'returns the user option' do
        expect(subject.keep_completed_modules?).to be_truthy
      end
    end
  end

  def missing_answers
    subject_ids = []
    shifts = { 1 => :mid, 2 => :morning }
    MeSalva::StudyPlan::Answers.new(subject_ids: subject_ids,
                                    shifts: shifts,
                                    keep_completed_modules: true)
  end
end
