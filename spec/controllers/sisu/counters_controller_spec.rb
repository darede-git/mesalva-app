# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'an accessible counters public route' do
  %w[guest user admin].each do |role|
    before { build_session(role) }

    context.skip "as #{role}" do
      it "returns all entities" do
        get :index, params: valid_attributes

        expect(response.headers.keys).not_to include_authorization_keys
        assert_type_and_status(:ok)
        expect(parsed_response['meta']['institute-count']).to eq(1)
        expect(parsed_response['meta']['max-passing-score'])
          .to eq(sisu.passing_score.to_f)
        expect(parsed_response['meta']['min-passing-score'])
          .to eq(sisu.passing_score.to_f)
      end
    end
  end
end

RSpec.describe Sisu::CountersController, type: :controller do
  let!(:sisu) { create(:sisu_institute) }
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
    it_behaves_like 'an accessible counters public route'
  end
end
