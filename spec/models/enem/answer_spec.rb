# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enem::Answer, type: :model do
  context 'validations' do
    should_be_present(:question, :value, :correct_value, :alternative)
  end
end
