# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Teacher::InvitationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/teacher/invitation')
        .to route_to('teacher/invitations#create')
    end

    it 'routes to #update' do
      expect(put: '/teacher/invitation')
        .to route_to('teacher/invitations#update')
    end
  end
end
