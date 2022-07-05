# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/user').to route_to('user/registrations#create')
    end
  end
end
