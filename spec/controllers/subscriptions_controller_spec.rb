# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:revenuecat_webhook_response) do
    JSON.parse(File.read('spec/fixtures/revenuecat_webhook_response.json'))
  end
  let(:subscriber) { '01234567890' }
  let(:product) { 'product_example1' }
  describe 'POST #revoke_subscription' do
    context 'through RevenueCat API' do
      before do
        url = "https://api.revenuecat.com/v1/"
        url += "subscribers/#{subscriber}/subscriptions/#{product}/revoke"
        allow(HTTParty).to receive(:post)
          .with(url, body: '', headers: headers)
          .and_return(http_party_200_response(revenuecat_webhook_response))
      end
      it 'revokes a users products subscription' do
        post :revoke_subscription, params: { app_user_id: subscriber, product: product }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  def headers
    { "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['REVENUE_CAT_SECRET_API_KEY']}" }
  end
end
