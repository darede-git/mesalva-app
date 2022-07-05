# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::AccessesController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/permalink_accesses/example')
        .to route_to('permalink/accesses#show', slug: 'example')
    end
  end
end
