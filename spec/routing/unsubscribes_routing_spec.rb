# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnsubscribesController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/unsubscribes/1')
        .to route_to('unsubscribes#update', subscription_id: '1')
    end
  end
end
