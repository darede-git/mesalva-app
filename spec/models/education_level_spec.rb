# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationLevel, type: :model do
  context 'validations' do
    should_be_present(:name)
  end
end
