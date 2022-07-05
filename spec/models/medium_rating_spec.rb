# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediumRating, type: :model do
  context 'validations' do
    it { should belong_to(:medium) }
    it { should belong_to(:user) }
  end
end
