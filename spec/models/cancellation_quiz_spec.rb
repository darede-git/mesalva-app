# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancellationQuiz, type: :model do
  context 'validations' do
    should_be_present(:order_id, :user_id, :quiz)
  end
end
