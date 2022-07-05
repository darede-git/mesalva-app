# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeMedium, type: :model do
  context 'validations' do
    should_belong_to(:node, :medium)
  end
end
