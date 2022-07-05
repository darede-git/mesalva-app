# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Event::User::Content::TestRepository do
  subject { described_class.new(user) }

  describe.skip '.counters' do
    it 'returns user consumption counters' do
      expect(subject.counters).not_to be_nil
    end
  end
end
