# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscountsCampaign::CarnavalController, type: :controller do
  describe 'POST #create' do
    it_behaves_like 'a unauthorized create route for', %w[admin guest]

    context 'as user' do
      before { user_session }

      context 'valid attributes' do
        it 'returns http created' do
          post :create

          assert_jsonapi_response(:created, Discount.last, DiscountSerializer)
        end
      end
    end
  end
end
