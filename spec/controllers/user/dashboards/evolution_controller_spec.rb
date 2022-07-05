# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Dashboards::EvolutionController, type: :controller do
  describe.skip 'GET #index' do
    context 'with user' do
      before { user_session }

      it 'returns user consumption' do
        get :index

        assert_type_and_status(:ok)

        expect(parsed_response['results']).to include('essay',
                                                      'exercise',
                                                      'video',
                                                      'book',
                                                      'streaming',
                                                      'text',
                                                      'public_document')
      end
    end

    context 'without user' do
      it 'returns unauthorized status' do
        get :index

        assert_type_and_status(:unauthorized)
      end
    end
  end
end
