# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::InvitationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/admin/invitation').to route_to('admin/invitations#create')
    end

    it 'routes to #update' do
      expect(put: '/admin/invitation').to route_to('admin/invitations#update')
    end
  end
end
