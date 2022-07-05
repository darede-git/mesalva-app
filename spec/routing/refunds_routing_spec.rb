# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefundsController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/refunds/1')
        .to route_to('refunds#update', order_id: '1')
    end
  end
end
