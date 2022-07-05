# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSetting, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
  end
end
