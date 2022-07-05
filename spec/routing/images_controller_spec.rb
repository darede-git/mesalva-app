# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImagesController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/images')
        .to route_to('images#create')
    end
  end
end
