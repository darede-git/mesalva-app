# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/user/sign_in').to route_to('user/sessions#create')
    end

    it 'also routes to #create' do
      expect(post: '/user/facebook/callback')
        .to route_to('user/sessions#create', provider: 'facebook')
    end

    it 'routes to #cross_platform' do
      expect(post: '/user/sign_in/IOS')
        .to route_to('user/sessions#cross_platform', platform: 'IOS')
    end
  end
end
