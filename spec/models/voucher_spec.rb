# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voucher, type: :model do
  context 'validations' do
    should_be_present(:order, :user)
    should_belong_to(:user, :access, :order)
    should_validate_uniqueness_of(:token)
  end
end
