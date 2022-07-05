# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeModuleMedium, type: :model do
  context 'validations' do
    should_belong_to(:node_module, :medium)
  end
end
