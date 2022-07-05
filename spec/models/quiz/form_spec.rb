# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::Form, type: :model do
  context 'validations' do
    should_be_present(:name, :form_type, :description)
    should_have_many(:form_submissions)
    it do
      should validate_inclusion_of(:form_type)
        .in_array(%w[study_plan answer_grid standard])
    end
    it { should have_many(:questions).order(position: :asc, id: :asc) }
  end
end
