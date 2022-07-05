# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ImpersonationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: 'admin/impersonations')
        .to route_to('admin/impersonations#create')
    end
  end
end
