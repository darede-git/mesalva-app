# frozen_string_literal: true

require 'rails_helper'

RSpec.describe College, type: :model do
  context 'validations' do
    should_be_present(:name)

    should_have_many(:scholar_records)
    should_validate_have_and_belong_to_many(:majors)
  end
end
