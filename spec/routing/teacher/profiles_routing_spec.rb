# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teacher::ProfilesController, type: :routing do
  describe 'routing' do
    it 'routes to #update' do
      expect(put: '/teacher/profiles').to route_to('teacher/profiles#update')
    end
  end
end
