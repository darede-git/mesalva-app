# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::SuggestionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/permalink_suggestions/example')
        .to route_to('permalink/suggestions#index', slug: 'example')
    end
  end
end
