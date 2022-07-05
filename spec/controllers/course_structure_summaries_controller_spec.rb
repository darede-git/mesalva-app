# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CourseStructureSummariesController, type: :controller do
  let(:valid_params) { FactoryBot.attributes_for(:course_structure_summary) }
  let(:invalid_params) do
    FactoryBot.attributes_for(:course_structure_summary, active: false)
  end

  context 'valid params' do
    context '#index' do
      before do
        create(:course_structure_summary)
        authentication_headers_for(admin)
      end

      let!(:unlisted) do
        create(:course_structure_summary,
               :different_slug, listed: false)
      end

      it 'brings listed course structures' do
        get :index
        expect(parsed_response).not_to be_empty
        expect(parsed_response).not_to include(unlisted)
      end
    end

    context '#show' do
      before { create(:course_structure_summary) }
      it 'returns unprocessable entity' do
        get :show, params: { slug: 'extensivo-enem' }

        expect(response).to have_http_status(:ok)
      end
    end

    context '#create' do
      before { authentication_headers_for(admin) }
      it 'creates a new course structure summary' do
        expect { post :create, params: valid_params }
          .to change(CourseStructureSummary, :count).by(1)
      end
    end

    context '#update' do
      before { authentication_headers_for(admin) }
      let!(:course_structure) { create(:course_structure_summary) }

      it 'updates the course structure accordingly' do
        put :update, params: { id: course_structure.id, slug: 'new slug' }

        expect(response).to have_http_status(:ok)
        expect(parsed_response['slug']).to eq('new slug')
      end
    end

    context '#destroy' do
      before { authentication_headers_for(admin) }
      let!(:course_structure) { create(:course_structure_summary) }

      it 'updates the course structure accordingly' do
        expect { delete :destroy, params: { id: course_structure.id } }
          .to change(CourseStructureSummary, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end

  context 'invalid params' do
    context '#show' do
      it 'returns not found' do
        get :show, params: { slug: 'abc' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context '#create' do
      before { authentication_headers_for(admin) }
      it 'does not creates a new course structure summary' do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '#update' do
      before { authentication_headers_for(admin) }
      let!(:course_structure) { create(:course_structure_summary) }

      it 'updates the course structure accordingly' do
        put :update, params: { id: course_structure.id, active: nil }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
