# frozen_string_literal: true

RSpec.shared_examples 'a valid session' do
  before do
    Timecop.freeze(Time.now)
    resource
    mock_intercom_create_user
    @request.headers[:client] = 'WEB'
  end

  it 'creates a new session' do
    post :create, params: { email: email, password: password }

    assert_action_response(resource_response, :accepted)
    expect(response.headers.keys).to include_authorization_keys
  end
end

RSpec.shared_examples 'an unauthorized session for inactive resource' do
  context 'for an resource inactive' do
    before do
      resource.active = false
      resource.save
    end

    it 'returns unauthorized' do
      post :create, params: { email: resource.email, password: password }

      assert_session_unauthorized(unauthorized_response)
    end
  end
end

RSpec.shared_examples 'an unauthorized session for invalid credentials' do
  context 'for an invalid credentials' do
    it 'returns invalid credentials message' do
      post :create, params: { email: resource.email, password: 'invalid' }

      assert_session_unauthorized(error_response)
    end
  end
end

RSpec.shared_examples 'an unauthorized session for an inexistent resource' do
  context 'for an inexistent resource' do
    it 'returns an error hash with unprocessable entity status' do
      post :create, params: { email: 'non@exists.com', password: 'any' }

      assert_session_unauthorized(error_response)
    end
  end
end

RSpec.shared_examples 'a session destroyer' do
  context 'with valid session' do
    before { authentication_headers_for(resource) }

    it 'returns http no content' do
      delete :destroy

      expect(response).to have_http_status(:success)
      expect(parsed_response).to eq('success' => true)
      expect(response.content_type).to eq(nil)
      expect(response.headers.keys).not_to include_authorization_keys
    end
  end
end

def assert_session_unauthorized(error)
  assert_action_response(error, :unauthorized)
  expect(response.headers.keys).not_to include_authorization_keys
end
