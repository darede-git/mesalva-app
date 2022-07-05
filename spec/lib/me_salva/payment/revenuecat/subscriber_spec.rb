# frozen_string_literal: true

describe MeSalva::Payment::Revenuecat::Subscriber do
  let(:subscriber) { '01234567890' }
  let(:product) { 'product_example1' }
  let(:revenuecat_webhook_response) do
    JSON.parse(File.read('spec/fixtures/revenuecat_webhook_response.json'))
  end
  describe '#revoke subscription' do
    context 'call' do
      before do
        url = "https://api.revenuecat.com/v1/subscribers/#{subscriber}/"\
        "subscriptions/#{product}/revoke"
        allow(HTTParty).to receive(:post)
          .with(url, body: '', headers: headers)
          .and_return(http_party_200_response(revenuecat_webhook_response))
      end
      it 'should perform' do
        expect(described_class.new(subscriber)
        .revoke_subscription(product)[:body]).to eq(revenuecat_webhook_response)
      end
    end
  end
  def headers
    { "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{ENV['REVENUE_CAT_SECRET_API_KEY']}" }
  end
end
