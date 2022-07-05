# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SessionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/admin/sign_in').to route_to('admin/sessions#create')
    end
  end
end
