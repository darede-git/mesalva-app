# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MediaController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/media/algebra?permalink_slug=enem/matematica')
        .to route_to('media#show',
                     slug: 'algebra',
                     permalink_slug: 'enem/matematica')
    end
  end
end
