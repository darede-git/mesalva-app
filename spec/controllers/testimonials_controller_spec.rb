# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestimonialsController, type: :controller do
  include ContentStructureAssertionHelper

  let!(:testimonial) do
    create(:testimonial)
  end
  let(:valid_attributes) do
    { text: 'Com o Me Salva!, me formei em engenharia!',
      user_name: 'Mario Souza',
      created_by: admin.uid,
      updated_by: admin.uid,
      avatar: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUhE"\
 "UgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAFAAH/VscvDQAAAABJRU5ErkJggg==',
      education_segment_slug: 'enem-semestral',
      created_at: '12 May 2017 00:00:00 UTC +00:00' }
  end

  describe 'GET index' do
    it 'returns a list of testimonials' do
      get :index

      assert_jsonapi_response(:success, [testimonial], TestimonialSerializer)
    end
  end

  describe 'GET show' do
    it 'returns a testimonial' do
      get :show, params: {
        education_segment_slug: testimonial.education_segment_slug
      }

      assert_jsonapi_response(:success, testimonial, TestimonialSerializer)
    end
  end

  describe 'POST create' do
    it_behaves_like 'creates a question, faq or testimonial' do
      let(:model) { Testimonial.last }
      let(:serializer_class) { TestimonialSerializer }
    end
  end

  describe 'PUT update' do
    before { admin_session }
    it 'updates a testimonial' do
      put :update, params: {
        id: testimonial.token,
        text: 'Passei em cálculo graças ao Me Salva!'
      }

      testimonial.reload
      assert_jsonapi_response(:ok, testimonial, TestimonialSerializer)
      assert_updated_by(testimonial, admin)
      expect(testimonial.text)
        .to eq('Passei em cálculo graças ao Me Salva!')
    end
  end

  describe 'DELETE destroy' do
    before { admin_session }
    it 'destroys a testimonial' do
      delete :destroy, params: { id: testimonial.token }

      expect(response).to have_http_status(:no_content)
    end
  end
end
