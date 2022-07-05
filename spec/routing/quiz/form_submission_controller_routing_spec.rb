# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::FormSubmissionsController, type: :routing do
  describe 'routing' do
    it 'routes to #last_submission' do
      expect(get: '/quiz/forms/1/form_submissions')
        .to route_to('quiz/form_submissions#last_user_submission', form_id: '1')
    end
  end
end
