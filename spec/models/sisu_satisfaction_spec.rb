# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SisuSatisfaction, type: :model do
  context 'validations' do
    should_belong_to(:user)
    should_be_present(:user)
  end
end
