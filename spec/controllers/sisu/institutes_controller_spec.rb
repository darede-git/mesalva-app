# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sisu::InstitutesController, type: :controller do
  let!(:sisu_institute) { create(:sisu_institute) }
  let!(:course) do
    create(:quiz_alternative, description: "ADMINISTRAÇÃO")
  end
  let!(:state) do
    create(:quiz_alternative, description: "Rio de Janeiro - RJ")
  end
  let!(:modality) do
    create(:quiz_alternative, description: "Ampla Concorrência")
  end
  let(:valid_attributes) do
    { course: course.id,
      state: state.id,
      modality: modality.id }
  end

  describe 'GET index' do
    it_behaves_like 'a unauthorized index route for', %w[admin guest]

    context 'as user' do
      before { user_session }
      context.skip 'with valid attributes' do
        it 'returns all entities' do
          get :index, params: valid_attributes

          assert_jsonapi_response(:ok,
                                  [sisu_institute],
                                  SisuInstituteSerializer)
        end
      end
    end
  end
end
