# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::FeatureEventsController, type: :controller do
  let(:next_payload) { payload_for('next') }
  let(:week_payload) { payload_for('week.1') }
  let(:next_response) { response_for('next') }
  let(:week_response) { response_for('week.1') }
  let(:event_list_response) do
    { 'data' => {
      'id' => user.uid,
      'type' => 'week',
      'attributes' => {
        'modules' => ['nnin-intro-as-ciencias-da-natureza-25']
      }
    } }
  end
  let(:week_destroy_payload) do
    {
      id: 'nnin-intro-as-ciencias-da-natureza',
      'feature' => 'syllabus',
      'section' => 'extensivo-enem',
      'context' => 'week.1',
      'module' => node_module
    }
  end
  let(:event_destroy_response) do
    { 'data' => {
      'id' => user.uid,
      'type' => "week",
      "attributes" => { "modules" => ["nnin-intro-as-ciencias-da-natureza-2"] }
    } }
  end

  describe 'POST #create' do
    context 'as a visitor' do
      it 'returns unauthorized' do
        post :create, params: { feature: 'syllabus' }

        assert_status_response(:unauthorized)
      end
    end
    context 'as an user' do
      before { build_session('user') }
      context 'creating a next module event' do
        it 'creates the next viewable module' do
          post :create, params: next_payload

          assert_type_and_status(:created)
          expect(parsed_response).to eq(next_response)
        end
      end

      context 'setting a module as viewed' do
        it 'pushes the module to a list and returns the list' do
          post :create, params: week_payload

          assert_type_and_status(:created)
          expect(parsed_response).to eq(week_response)
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:event_key) { "syllabus.extensivo-enem.#{user.uid}.next" }

    context 'as a visitor' do
      it 'returns unauthorized' do
        get :show, params: { feature: 'syllabus' }

        assert_status_response(:unauthorized)
      end
    end
    context 'as an user' do
      let(:body) do
        { 'feature' => 'syllabus',
          'section' => 'extensivo-enem',
          'context' => 'next' }
      end

      before { build_session('user') }
      context 'a non existing key' do
        before do
          Redis.current.del(event_key)
        end
        it 'returns not found status' do
          get :show, params: body

          assert_type_and_status(:not_found)
        end
      end
      context 'an existing key' do
        before do
          event_key = "syllabus.extensivo-enem.#{user.uid}.next"
          Redis.current.set(event_key, next_payload['module'])
        end
        it 'returns the next viewable module' do
          get :show, params: body

          assert_type_and_status(:ok)

          expect(parsed_response).to eq(next_response)
        end
      end
    end
  end

  describe 'GET #index' do
    let!(:week1) { "syllabus.extensivo-enem.#{user.uid}.week.1" }
    let!(:week2) { "syllabus.extensivo-enem.#{user.uid}.week.2" }

    context 'as a visitor' do
      it 'returns unauthorized' do
        get :index, params: { feature: 'syllabus' }

        assert_status_response(:unauthorized)
      end
    end
    context 'as an user' do
      before do
        build_session('user')
        Redis.current.del(week1)
        Redis.current.del(week2)
        Redis.current.rpush(week1, 'nnin-intro-as-ciencias-da-natureza-1')
        Redis.current.rpush(week2, 'nnin-intro-as-ciencias-da-natureza-25')
      end
      it 'returns a list of consumed modules for the context' do
        get :index, params: { 'feature' => 'syllabus',
                              'section' => 'extensivo-enem',
                              'context' => 'week.2' }

        assert_type_and_status(:ok)
        expect(parsed_response).to eq(event_list_response)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:week1) { "syllabus.extensivo-enem.#{user.uid}.week.1" }
    let!(:week2) { "syllabus.extensivo-enem.#{user.uid}.week.2" }

    context 'as a visitor' do
      it 'returns unauthorized' do
        delete :destroy, params: week_destroy_payload

        assert_status_response(:unauthorized)
      end
    end
    context 'as an user' do
      before do
        build_session('user')
        Redis.current.del(week1)
        Redis.current.rpush(week1, 'nnin-intro-as-ciencias-da-natureza')
        Redis.current.rpush(week1, 'nnin-intro-as-ciencias-da-natureza-2')
      end
      it 'returns a list of consumed modules for the context' do
        delete :destroy, params: week_destroy_payload

        assert_type_and_status(:ok)
        expect(parsed_response).to eq(event_destroy_response)
      end
    end
  end

  def payload_for(event_context)
    { 'feature' => 'syllabus',
      'section' => 'extensivo-enem',
      'context' => event_context,
      'module' => node_module }
  end

  def response_for(event_context, number = '1')
    type = event_context.split('.').first
    { 'data' => { 'id' => user.uid, 'type' => type,
                  'attributes' => node_module(number) } }
  end

  def node_module(number = '1')
    { 'name' => 'NNIN - Ciencias da Natureza: O que é?',
      'slug' => 'nnin-intro-as-ciencias-da-natureza',
      'permalink' => 'enem-e-vestibulares/materias',
      'number' => number }
  end
end
