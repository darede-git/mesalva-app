# frozen_string_literal: true

module JsonResponseHelper
  def success_response(**meta)
    { 'data' =>
      { 'id' => meta[:id], 'type' => meta[:type],
        'attributes' => attributes(**meta),
        'relationships' => { 'address' => { 'data' => nil },
                             'academic-info' => { 'data' => nil },
                             'education-level' => { 'data' => nil },
                             'objective' => { 'data' => nil } } } }
  end

  def unauthorized_response
    { 'errors' => [t('devise.failure.unauthenticated')] }
  end

  def forbidden_response
    { 'errors' => [t('errors.messages.forbidden')] }
  end

  def attributes(meta)
    { 'provider' => meta[:provider], 'uid' => meta[:uid], 'name' => meta[:name],
      'image' => { 'url' => nil }, 'email' => meta[:email], 'birth-date' => nil,
      'gender' => nil, 'studies' => nil, 'dreams' => nil, 'premium' => false,
      'origin' => nil, 'active' => true, 'created-at' => meta[:created_at],
      'crm-email' => meta[:crm_email], 'enem-subscription-id' => meta[:enem_subscription_id],
      'facebook-uid' => meta[:facebook_uid],
      'google-uid' => nil, 'token' => meta[:token], 'phone-area' => nil,
      'phone-number' => nil, 'profile' => nil, 'options' => meta[:options] }
  end

  def assert_status_response(status)
    expect(parsed_response).to eq(status_response(status))
    assert_type_and_status(status.to_sym)
  end

  def status_response(status)
    # rubocop:disable Style/DocumentDynamicEvalDefinition
    instance_eval("#{status}_response", __FILE__, __LINE__)
    # rubocop:enable Style/DocumentDynamicEvalDefinition
  end

  def assert_action_response(action_response, status)
    expect(parsed_response).to eq(action_response)
    assert_type_and_status(status)
  end

  def assert_jsonapi_response(status, model, serializer = Object, attrs = nil)
    parsed_response = to_jsonapi(model, serializer, attrs)
    expect(JSON.parse(response.body)).to eq(JSON.parse(parsed_response))
    assert_type_and_status(status)
  end

  def assert_apiv2_response(status, model, serializer, includes = nil, meta = nil)
    assert_type_and_status(status)
    expect(JSON.parse(response.body))
      .to eq(JSON.parse(serializer.new(model, include: includes, meta: meta).serialized_json))
  end

  def assert_apiv3_response(status, model, serializer, includes = nil, meta = nil)
    assert_type_and_status(status)
    expect(JSON.parse(response.body))
      .to eq(JSON.parse(serializer.new(model, include: includes, meta: meta).serialized_json))
  end

  def assert_headers_for(resource)
    expect(response.headers['uid']).to eq(resource.uid)
  end

  def assert_type_and_status(status)
    expect(response.content_type).to eq(Mime[:json])
    expect(response).to have_http_status(status)
  end
end
