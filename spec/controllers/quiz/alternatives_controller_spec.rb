# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Quiz::AlternativesController, type: :controller do
  let(:valid_attributes) do
    FactoryBot.attributes_for(:quiz_alternative, quiz_question_id: question.id)
  end
  let(:invalid_attributes) do
    FactoryBot.attributes_for(:quiz_alternative, description: '')
  end
  let(:new_attributes) { { description: 'new statement' } }

  let(:question) { create(:quiz_question) }
  let!(:entity) { create(:quiz_alternative) }

  let(:default_serializer) { Quiz::AlternativeSerializer }
  let(:default_model) { Quiz::Alternative }

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
