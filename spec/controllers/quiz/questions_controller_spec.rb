# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Quiz::QuestionsController, type: :controller do
  let(:valid_attributes) do
    FactoryBot.attributes_for(:quiz_question, quiz_form_id: form.id)
  end
  let(:invalid_attributes) do
    FactoryBot.attributes_for(:quiz_question, statement: '',
                                              question_type: 'field')
  end
  let(:new_attributes) { { question_type: 'radio' } }

  let(:form) { create(:quiz_form) }
  let!(:entity) { create(:quiz_question) }

  let(:default_serializer) { Quiz::QuestionSerializer }
  let(:default_model) { Quiz::Question }

  describe "GET #index" do
    it_behaves_like 'a accessible index public route'
  end

  describe "GET #show" do
    it_behaves_like 'a accessible show public route'
  end

  describe "POST #create" do
    it_behaves_like 'a accessible create route for', %w[admin]
    it_behaves_like 'a unauthorized create route for', %w[user guest]
  end

  describe "PUT #update" do
    it_behaves_like 'a accessible update route for', %w[admin]
    it_behaves_like 'a unauthorized update route for', %w[user guest]
  end

  describe "DELETE #destroy" do
    it_behaves_like 'a accessible destroy route for', %w[admin]
    it_behaves_like 'a unauthorized destroy route for', %w[user guest]
  end

  context 'entity does not exist' do
    it_behaves_like 'a not found response for action', %i[show update destroy]
  end
end
