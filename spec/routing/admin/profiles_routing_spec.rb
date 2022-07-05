# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/admin/profiles').to route_to('admin/profiles#update')
    end
  end
end
