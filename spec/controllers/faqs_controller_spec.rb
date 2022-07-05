# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FaqsController, type: :controller do
  include ContentStructureAssertionHelper

  let!(:specific_purpose_faq) do
    create(:faq, :specific_purpose_faq)
  end

  let!(:general_purpose_faq) do
    create(:faq, :general_purpose_faq)
  end

  let(:valid_attributes) do
    { name: 'Reembolso',
      slug: 'me-salva' }
  end
  let!(:user) { create(:user) }

  describe 'GET index' do
    it 'returns a list of faq with the same slug' do
      get :index, params: { slug: specific_purpose_faq.slug }

      assert_jsonapi_response(:success, [specific_purpose_faq],
                              FaqSerializer)
    end
  end

  describe 'GET index' do
    it 'retunrs a list os all faqs' do
      get :index

      assert_jsonapi_response(:success, [specific_purpose_faq,
                                         general_purpose_faq], FaqSerializer)
    end
  end

  describe 'POST create' do
    it_behaves_like 'creates a question, faq or testimonial' do
      let(:model) { Faq.last }
      let(:serializer_class) { FaqSerializer }
    end
  end

  describe 'PUT update' do
    before { admin_session }
    it 'updates a faq' do
      put :update, params: { id: general_purpose_faq.token,
                             name: 'Cancelamentos' }

      general_purpose_faq.reload
      assert_jsonapi_response(:ok, general_purpose_faq,
                              FaqSerializer)
      assert_updated_by(general_purpose_faq, admin)
    end
  end

  describe 'DELETE destroy' do
    before { admin_session }
    it 'destroys a faq' do
      delete :destroy, params: { id: general_purpose_faq.token }

      expect(response).to have_http_status(:no_content)
      expect(parsed_response).to eq('success' => true)
      expect(response.content_type).to eq(nil)
    end
  end
end
