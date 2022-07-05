# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include ContentStructureAssertionHelper

  let!(:question) do
    create(:question, :general_question)
  end
  let(:valid_attributes) do
    { title: 'O que é o Me Salva!?',
      answer: 'O Me Salva! é uma plataforma',
      image: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
 "UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
      faq_id: faq.token }
  end
  let!(:faq) do
    create(:faq,
           :specific_purpose_faq)
  end

  describe 'POST create' do
    before { admin_session }
    it_behaves_like 'creates a question, faq or testimonial' do
      let(:model) { Question.last }
      let(:serializer_class) { QuestionSerializer }
    end
  end

  describe 'GET show' do
    it 'returns a question' do
      question = Question.last
      get :show, params: { faq_id: question.faq, id: question.token }

      assert_jsonapi_response(:ok, question, QuestionSerializer)
    end
  end

  describe 'PUT update' do
    before { admin_session }
    it 'updates a question' do
      put :update, params: { faq_id: question.faq,
                             id: question.token,
                             title: 'Quando o Me Salva! surgiu?',
                             answer: 'Em 2013' }

      question.reload
      assert_jsonapi_response(:ok, question, QuestionSerializer)
      expect(question.title).to eq('Quando o Me Salva! surgiu?')
      expect(question.answer).to eq('Em 2013')
      assert_updated_by(question, admin)
    end
  end

  describe 'DELETE destroy' do
    before { admin_session }
    it 'destroys a question' do
      delete :destroy, params: { faq_id: question.faq, id: question.token }

      expect(response).to have_http_status(:no_content)
      expect(response.content_type).to eq(nil)
    end
  end
end
