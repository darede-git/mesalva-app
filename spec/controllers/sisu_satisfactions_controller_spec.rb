# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SisuSatisfactionsController, type: :controller do
  let(:valid_attributes) { attributes_for(:sisu_satisfaction) }

  describe 'POST #create' do
    it_behaves_like 'a unauthorized create route for', %w[admin guest]

    context 'as user' do
      before { user_session }

      context "with valid params" do
        it "creates a new entity and returns it" do
          expect do
            post :create, params: valid_attributes
          end.to change(SisuSatisfaction, :count).by(1)

          assert_jsonapi_response(:created,
                                  SisuSatisfaction.last,
                                  SisuSatisfactionSerializer)
        end
      end
    end
  end
end
