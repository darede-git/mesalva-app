# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Dashboards, type: :routing do
  describe 'evolution' do
    it 'routes to evolution #index' do
      expect(get: '/user/dashboards')
        .to route_to('user/dashboards/evolution#index')
      expect(get: '/user/dashboards/evolution')
        .to route_to('user/dashboards/evolution#index')
    end
  end
  describe 'test repository' do
    it 'routes to test_repository #index' do
      expect(get: '/user/dashboards/test_repository')
        .to route_to('user/dashboards/test_repository#index')
    end
  end
end
