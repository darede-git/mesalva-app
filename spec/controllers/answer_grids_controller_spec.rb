# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AnswerGridsController, type: :controller do
  let(:entity) { create(:enem_answer_grid) }
  let(:default_serializer) { Enem::AnswerGridSerializer }
  let(:default_model) { Enem::AnswerGrid }

  describe "GET #index" do
    it_behaves_like 'a unauthorized index route for', %w[admin guest]

    context 'user' do
      let!(:answer_grid) { create(:enem_answer_grid, user: user) }
      it "returns answer grids disctint on exam by user and year" do
        build_session('user')
        get :index, params: { year: 2018 }

        assert_jsonapi_response(:ok, [answer_grid],
                                default_serializer, [:answers])
      end
    end
  end
end
