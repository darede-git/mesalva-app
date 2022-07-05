# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment::EssaySubmissionsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/essay_submissions/1/comments')
        .to route_to('comment/essay_submissions#create',
                     essay_submission_id: '1')
    end

    it 'routes to #update' do
      expect(put: '/essay_submissions/1/comments/abc')
        .to route_to('comment/essay_submissions#update',
                     token: 'abc', essay_submission_id: '1')
    end
  end
end
