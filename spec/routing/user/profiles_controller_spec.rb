# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/user/profiles').to route_to('user/profiles#update')
    end

    it 'routes to #show' do
      expect(get: '/user/profiles').to route_to('user/profiles#show')
    end
  end
end
