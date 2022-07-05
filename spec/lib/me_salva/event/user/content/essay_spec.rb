# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Event::User::Content::Essay do
  subject { described_class.new(user) }

  describe '.counters' do
    it 'returns essay consumption counters' do
      expect(subject.counters).to eq('total' => { 'max-grade' => 0,
                                                  'count' => 0 },
                                     'week' => { 'count' => 0 })
    end
  end
end
