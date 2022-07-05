# frozen_string_literal: true

RSpec.shared_context "session" do
  let(:password) { '123456' }
  let(:resource_email) { 'person@mesalva.com' }
  let(:error_response) do
    { 'errors' => [t('devise_token_auth.sessions.bad_credentials')] }
  end

  let(:unauthorized_response) do
    { 'errors' => [t('devise.failure.unauthenticated')] }
  end
end
