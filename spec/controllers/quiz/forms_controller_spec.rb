# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::FormsController, type: :controller do
  let(:valid_attributes) { FactoryBot.attributes_for(:quiz_form) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:quiz_form, name: '') }
  let(:new_attributes) { { name: 'new name' } }

  let!(:entity) { create(:quiz_form) }

  let(:default_serializer) { Quiz::FormSerializer }
  let(:default_model) { Quiz::Form }

  describe "GET #index" do
    it_behaves_like 'a accessible index public route'
  end

  describe "GET #show" do
    it_behaves_like 'a accessible show public route'
    context 'with related questions and alternatives' do
      let(:entity) do
        load('db/seeds/production/1-study_plan_form_questions.seeds.rb')
        Quiz::Form.first
      end
      it 'returns related questions and alternatives' do
        get :show, params: { id: entity.id }

        included_types = parsed_response['included'].map { |i| i['type'] }.uniq
        expect(included_types).to eq %w[quiz-questions quiz-alternatives]
        expect(parsed_response['included'].count).to eq 31
        expect(parsed_response['included'].second['attributes']).to \
          eq("description" => "Domingo|Manhã", "value" => "0|morning")
        expect(parsed_response['included'].first['attributes']).to \
          eq('statement' => "Quais dias você pretende estudar?",
             'question-type' => 'checkbox_table',
             'description' => nil,
             'required' => false)
      end
    end
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
