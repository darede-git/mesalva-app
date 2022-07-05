# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Campaign::VoucherController, type: :routing do
  describe 'routing' do
    it 'routes to #campaign/voucher' do
      expect(post: '/campaign/voucher')
        .to route_to('campaign/voucher#create')
    end
  end
end
