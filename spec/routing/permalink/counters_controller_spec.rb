# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::CountersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/permalink_counters/example')
        .to route_to('permalink/counters#show', slug: 'example')
    end
  end
end
