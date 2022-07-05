# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Quiz::FormSubmissionsController, type: :controller do
  let(:valid_attributes) do
    {
      quiz_form_id: form.id,
      user_id: user.id,
      answers_attributes: [
        { quiz_question_id: Quiz::Question.last.id,
          value: 'answer' }
      ]
    }
  end
  let(:invalid_attributes) do
    FactoryBot.attributes_for(:quiz_form_submission, form: nil,
                                                     quiz_form_id: nil)
  end
  let(:new_attributes) { { quiz_form_id: new_form.id } }

  let(:form) { create(:quiz_form_with_questions, id: 1000) }
  let(:new_form) { create(:quiz_form, id: 1001) }
  let!(:entity) do
    ActiveRecord::Base
      .connection
      .execute('ALTER SEQUENCE quiz_questions_id_seq RESTART WITH 10;')
    create(:quiz_form_submission_with_answers, form: form)
  end

  let(:default_serializer) { Quiz::FormSubmissionSerializer }
  let(:default_model) { Quiz::FormSubmission }

  describe "GET #index" do
    it_behaves_like 'a accessible index route for', %w[admin]
    it_behaves_like 'a unauthorized index route for', %w[user guest]
  end

  describe "GET #show" do
    it_behaves_like 'a accessible show route for', %w[user]
    it_behaves_like 'a unauthorized show route for', %w[admin guest]
  end

  describe "POST #create" do
    it_behaves_like 'a accessible create route for', %w[user]
    it_behaves_like 'a unauthorized create route for', %w[admin guest]
    context 'with nested answer attributes' do
      context 'answer grid' do
        let!(:entity) do
          create(:quiz_form, :answer_grid, id: 2)
        end
        let!(:question1) do
          create(:quiz_question_with_alternative,
                 form: entity, id: 20)
        end
        let!(:question2) do
          create(:quiz_question_with_alternative,
                 form: entity, id: 21)
        end
        let!(:question3) do
          create(:answer_grid_quiz_question_52_with_alternatives,
                 form: entity)
        end
        let!(:question4) do
          create(:answer_grid_quiz_question_53_with_alternatives,
                 form: entity)
        end
        let!(:question5) do
          create(:answer_grid_quiz_question_110_with_alternatives,
                 form: entity)
        end
        let!(:question6) do
          create(:answer_grid_quiz_question_111, form: entity)
        end

        let(:answers_attributes) do
          [
            { quiz_question_id: question1.id,
              quiz_alternative_id: question1.alternatives[0] },
            { quiz_question_id: question2.id,
              quiz_alternative_id: question2.alternatives[1] },
            { quiz_question_id: question3.id,
              quiz_alternative_id: question3.alternatives[1] },
            { quiz_question_id: question4.id,
              quiz_alternative_id: question4.alternatives[0] },
            { quiz_question_id: question5.id,
              quiz_alternative_id: question5.alternatives[0] },
            { quiz_question_id: question6.id,
              value: 2018 }
          ]
        end

        let(:url) do
          "#{ENV['S3_CDN']}/data/lps/enem-answer-key/2018/linging_pink.json"
        end

        it 'saves all nested answers' do
          file = double
          allow(HTTParty).to receive(:get).with(url).and_return(file)
          allow(file).to receive(:success?).and_return(true)
          allow(file).to receive(:body)
            .and_return(File.read('spec/fixtures/answer_grid.json'))

          build_session('user')
          expect do
            post :create, params: { quiz_form_id: entity.id }.merge(
              answers_attributes: answers_attributes
            )
          end.to change(Quiz::FormSubmission, :count)
            .by(1).and change(Quiz::Answer, :count)
            .by(6).and change(Enem::AnswerGrid, :count)
            .by(1).and change(Enem::Answer, :count).by(2)

          expect(parsed_response['meta']).to include('answers-correct')
          expect(parsed_response['meta']).to include('exam')
        end

        context 'answer grid not found' do
          it 'returns unprocessable_entity' do
            file = double
            allow(HTTParty).to receive(:get).and_return(file)
            allow(file).to receive(:success?).and_return(false)

            build_session('user')
            post :create, params: { quiz_form_id: entity.id }.merge(
              answers_attributes: [
                {  quiz_question_id: question3.id,
                   quiz_alternative_id: question3.alternatives[0] },
                {  quiz_question_id: question4.id,
                   quiz_alternative_id: question4.alternatives[0] }
              ]
            )
            assert_action_response({ "errors" => ["Gabarito não disponível."] },
                                   :unprocessable_entity)
          end
        end
      end
    end
  end

  context 'GET #last_user_submission' do
    let!(:form_submission) do
      create(:quiz_form_submission_with_answers,
             quiz_form_id: form.id,
             user_id: user.id)
    end
    let!(:quiz_answer) do
      form_submission.answers.first
    end

    context 'as user' do
      before { build_session('user') }

      context 'entity exist' do
        it 'return last user submission' do
          get :last_user_submission, params: { form_id: form.id }

          assert_jsonapi_response(:ok, form_submission,
                                  Quiz::FormSubmissionSerializer, [:answers])
        end
      end

      context 'entity does not exist' do
        it 'returns http not found' do
          get :last_user_submission, params: { form_id: 0 }

          assert_type_and_status(:not_found)
        end
      end
    end

    context 'as admin' do
      before { build_session('admin') }
      it 'returns http unauthorized' do
        post :last_user_submission, params: { form_id: form.id }

        assert_type_and_status(:unauthorized)
      end
    end

    context 'as guest' do
      before { build_session('guest') }
      it 'returns http unauthorized' do
        post :last_user_submission, params: { form_id: form.id }

        assert_type_and_status(:unauthorized)
      end
    end
  end

  context 'entity does not exist' do
    it_behaves_like 'a not found response for action', %i[show]
  end
end
