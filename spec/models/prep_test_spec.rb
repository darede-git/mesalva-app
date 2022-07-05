# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrepTest, type: :model do
  it { should have_many(:prep_test_scores) }
  it { should validate_presence_of(:permalink_slug) }
  it { should validate_uniqueness_of(:permalink_slug) }
end
