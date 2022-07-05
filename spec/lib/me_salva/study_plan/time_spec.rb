# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::StudyPlan::Time do
  let(:shifts) do
    [{ 0 => :mid },
     { 0 => :morning },
     { 1 => :mid },
     { 1 => :morning },
     { 2 => :mid },
     { 2 => :morning },
     { 3 => :mid },
     { 3 => :morning },
     { 4 => :mid },
     { 4 => :morning },
     { 5 => :mid },
     { 5 => :morning },
     { 6 => :mid },
     { 6 => :morning }]
  end
  let(:starts_at) { time_parser(Time.now.to_s) }
  let(:ends_at) { time_parser((Time.now + 5.weeks).to_s) }

  subject { MeSalva::StudyPlan::Time.new(shifts, starts_at, ends_at) }

  before do
    time = Time.local(2012, 2, 12, 10, 45)
    Timecop.freeze(time)
  end

  after do
    Timecop.return
  end

  describe '.availability' do
    it 'returns total time available to study' do
      expect(subject.availability).to eq(210)
    end
  end

  describe '.full_weeks_total_hours' do
    it 'returns only full weeks total hours' do
      expect(subject.full_weeks_total_hours).to eq(168)
    end
  end

  describe '.remaining_days_hours' do
    it 'returns remaining days hours' do
      expect(subject.remaining_days_hours).to eq(36)
    end
  end

  describe '.first_day_hours' do
    it 'returns the first day hours' do
      expect(subject.first_day_hours).to eq(6)
    end
  end

  def time_parser(time)
    Time.parse(time)
  end
end
