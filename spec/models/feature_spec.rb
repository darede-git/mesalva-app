# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Feature, type: :model do
  context 'validations' do
    should_be_present(:name, :slug)
    should_have_many(:packages)
  end
end
