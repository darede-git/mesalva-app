# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::DateHelper do
  describe 'Date helpers' do
    context 'with valid date' do
      context 'with regular student birthdate' do
        let(:subject_date) { '1990-01-01'.to_date }
        it 'valid_date? should return true' do
          expect(described_class.valid_date?(subject_date)).to eq(true)
        end
        it 'valid_date_with_fallback should return the received date' do
          expect(described_class.valid_date_with_fallback(subject_date)).to eq(subject_date)
        end
      end
      context 'with limit student birthdate' do
        let(:subject_date) { '1980-01-01'.to_date }
        it 'valid_date? should return true' do
          expect(described_class.valid_date?(subject_date)).to eq(true)
        end
        it 'valid_date_with_fallback should return the received date' do
          expect(described_class.valid_date_with_fallback(subject_date)).to eq(subject_date)
        end
      end
    end

    context 'with nil date' do
      it 'valid_date? should return true' do
        expect(described_class.valid_date?(nil)).to eq(false)
      end
      it 'valid_date_with_fallback should return the fallback date' do
        expect(described_class.valid_date_with_fallback(nil)).to eq(Time.at(0).to_date)
      end
    end

    context 'with date < 1900-01-01' do
      let(:subject_date) { '1899-01-01'.to_date }
      it 'valid_date? should return true' do
        expect(described_class.valid_date?(subject_date)).to eq(false)
      end
      it 'valid_date_with_fallback should return the fallback date' do
        expect(described_class.valid_date_with_fallback(subject_date)).to eq(Time.at(0).to_date)
      end
    end
  end
end
