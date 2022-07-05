# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permalink::SuggestionsController, type: :controller do
  describe 'GET #index' do
    let!(:permalink_suggestion) { create(:permalink_suggestion) }
    let!(:permalink_suggestion2) { create(:permalink_suggestion) }
    let!(:permalink_suggestion3) do
      create(:permalink_suggestion, slug: 'invalid')
    end

    context "as user" do
      before { user_session }
      it "returns all entities" do
        get :index, params: { slug: permalink_suggestion.slug }

        assert_jsonapi_response(:ok,
                                [permalink_suggestion, permalink_suggestion2],
                                PermalinkSuggestionSerializer)
      end
    end

    context "as admin" do
      before { admin_session }
      it "returns http unauthorized" do
        get :index, params: { slug: permalink_suggestion.slug }

        assert_type_and_status(:unauthorized)
      end
    end
  end
end
