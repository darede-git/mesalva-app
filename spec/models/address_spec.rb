# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'validations' do
    should_be_present(:city, :state)
    it { should allow_value('').for(:zip_code) }
    it { should allow_value('12345-678').for(:zip_code) }
    it { should_not allow_value('12345678').for(:zip_code) }
    it { should_not allow_value('1234a-567').for(:zip_code) }
    it { should_not allow_value('12345-6789').for(:zip_code) }
    it { should_not allow_value('123456-789').for(:zip_code) }
    it { should_not allow_value('123456-7890').for(:zip_code) }
  end
end
