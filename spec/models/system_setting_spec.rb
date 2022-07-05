# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemSetting, type: :model do
  context 'validations' do
    should_be_present(:key)
  end
end
