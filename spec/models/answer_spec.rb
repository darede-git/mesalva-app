# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'validations' do
    should_be_present(:text)
  end
end
