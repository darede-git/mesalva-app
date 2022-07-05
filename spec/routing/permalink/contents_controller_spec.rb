# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::ContentsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/permalink_contents/example')
        .to route_to('permalink/contents#show', slug: 'example')
    end
  end
end
