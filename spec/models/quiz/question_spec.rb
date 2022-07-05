# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::Question, type: :model do
  context 'validations' do
    should_belong_to(:form)
    should_be_present(:statement, :form)
    should_have_many(:alternatives)
    it do
      should validate_inclusion_of(:question_type)
        .in_array(%w[checkbox radio text checkbox_table select])
    end
  end
end
