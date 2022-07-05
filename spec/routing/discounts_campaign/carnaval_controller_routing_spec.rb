# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountsCampaign::CarnavalController, type: :routing do
  describe 'routing' do
    it 'routes to #discounts_campaign/carnaval' do
      expect(post: '/discounts_campaign/carnaval')
        .to route_to('discounts_campaign/carnaval#create')
    end
  end
end
