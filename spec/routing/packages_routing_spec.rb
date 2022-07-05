# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/packages/slug')
        .to route_to('packages#update', slug: 'slug')
    end

    it 'routes to #show' do
      expect(get: '/packages/slug').to route_to('packages#show', slug: 'slug')
    end
  end
end
