# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::Alternative, type: :model do
  context 'validations' do
    should_belong_to(:question)
    should_be_present(:description, :value, :question)
  end
end
