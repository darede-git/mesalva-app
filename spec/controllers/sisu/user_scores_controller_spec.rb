# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sisu::UserScoresController, type: :controller do
  let!(:sisu_institute) { create(:sisu_institute, state: 'AC') }
  let(:entity) do
    load('db/seeds/production/3-sisu.seeds.rb')
    Quiz::Form.find(4)
  end

  let(:valid_attributes) do
    { quiz_form_id: 4,
      answers_attributes: [
        { quiz_question_id: entity.questions[0].id,
          quiz_alternative_id: entity.questions[0].alternatives[0] },
        { quiz_question_id: entity.questions[1].id,
          quiz_alternative_id: entity.questions[1].alternatives[0] },
        { quiz_question_id: entity.questions[2].id,
          quiz_alternative_id: entity.questions[2].alternatives[0] },
        { quiz_question_id: entity.questions[3].id,
          value: '500' },
        { quiz_question_id: entity.questions[4].id,
          value: '500' },
        { quiz_question_id: entity.questions[5].id,
          value: '500' },
        { quiz_question_id: entity.questions[6].id,
          value: '500' },
        { quiz_question_id: entity.questions[7].id,
          value: '500' }
      ] }
  end

  describe 'POST create' do
    context 'without user or partner token' do
      before do
        expect(CreateSisuScoreWorker).not_to receive(:perform_async)
      end

      it 'should return unprocessable entity' do
        expect do
          post :create, params: valid_attributes
        end.to change(Quiz::FormSubmission, :count).by(0)

        expect(response.status).to eq(422)
        expect(parsed_response['errors']).to eq([t('errors.messages.invalid_sisu_user_param')])
      end
    end

    context 'as partner user' do
      before do
        expect(CreateSisuScoreWorker).to receive(:perform_async)
      end

      it 'creates a new quiz form submission and returns scores' do
        expect do
          post :create, params: valid_attributes.merge(partner_user_token: user.token)
        end.to change(Quiz::FormSubmission, :count).by(1)

        assert_type_and_status(:created)
        expect(parsed_response['data']).not_to be_empty
        expect(parsed_response['meta']).to include('scores',
                                                   'max-passing-score',
                                                   'max-average',
                                                   'min-passing-score',
                                                   'min-average')
      end
    end

    context 'as user' do
      before do
        user_session
        expect(CreateSisuScoreWorker).to receive(:perform_async)
      end
      context.skip 'with valid attributes' do
        it 'creates a new quiz form submission and returns scores' do
          expect do
            post :create, params: valid_attributes
          end.to change(Quiz::FormSubmission, :count).by(1)

          assert_type_and_status(:created)
          expect(parsed_response['data']).not_to be_empty
          expect(parsed_response['meta']).to include('scores',
                                                     'max-passing-score',
                                                     'max-average',
                                                     'min-passing-score',
                                                     'min-average')
        end
      end
    end
  end
end
