# frozen_string_literal: true

require 'rails_helper'

RSpec.describe School, type: :model do
  context 'validations' do
    should_have_many(:scholar_records)
    should_be_present(:name)
    it { should validate_uniqueness_of :name }
  end
end
