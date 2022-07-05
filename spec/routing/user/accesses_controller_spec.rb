# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::AccessesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/accesses').to route_to('user/accesses#index')
    end

    it 'also routes to #create' do
      expect(post: '/accesses').to route_to('user/accesses#create')
    end
  end

  it 'routes to #destroy' do
    expect(put: '/accesses/1').to route_to('user/accesses#update', id: '1')
  end
end
