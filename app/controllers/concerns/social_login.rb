# frozen_string_literal: true

module SocialLogin
  extend ActiveSupport::Concern
  PROVIDERS = %w[facebook google apple].freeze
  private_constant :PROVIDERS

  def auth_hash
    user_info_from_provider
  end

  private

  def user_info_from_provider
    return omniauth_hash unless omniauth_hash.nil?
    return provider_hash if valid_provider?

    { 'error' => { 'message' =>
      t('devise_token_auth.sessions.invalid_provider') } }
  end

  def provider_hash
    social_graph_response if @graph.nil?
    return if @graph.include?('error')

    OmniAuth::AuthHash.new('provider' => params['provider'],
                           'uid' => @graph['id'],
                           'email' => @graph['email'],
                           'info' => { 'name' => @graph['name'],
                                       'gender' => @graph['gender'],
                                       'birth_date' => @graph['birthday'] })
  end

  def omniauth_hash
    request.env['omniauth.auth']
  end

  def social_graph_response
    if params['provider'] == 'apple'
      @graph ||= apple_graph
      return
    end

    @graph ||= HTTParty.get(provider_url).parsed_response
  end

  def authorized_token?
    social_graph_response
    return false if unauthorized_token?

    true
  end

  def unauthorized_token?
    return false unless @graph['error'].present?

    @graph['error']['code'] == 401
  end

  def malformed_token?
    return false unless @graph['error'].present?

    @graph['error']['code'] == 190 if @graph['error'].present?
  end

  def valid_provider?
    @provider ||= PROVIDERS.include? params['provider']
  end

  def provider_url
    return ENV['APPLE_OAUTH_LOGIN_URL'] if params['provider'] == 'apple'

    url = ENV["#{params['provider'].upcase}_OAUTH_LOGIN_URL"]
    "#{url}#{params['token']}"
  end

  def apple_token
    claims = {
      iss: ENV['APPLE_LOGIN_TEAM_ID'],
      aud: 'https://appleid.apple.com',
      sub: params['client_id'],
      iat: Time.now.to_i,
      exp: (Time.now + 6.months).to_i
    }

    pub_key = OpenSSL::PKey::EC.new(File.read(ENV['APPLE_LOGIN_PRIVATE_KEY']))
    headers = { kid: ENV['APPLE_LOGIN_KEY_ID'] }
    JWT.encode(claims, pub_key, 'ES256', headers)
  end

  def apple_graph
    payload = {
      "grant_type": 'authorization_code',
      "code": params['token'],
      "client_id": params['client_id'],
      "client_secret": apple_token
    }

    parsed_response = HTTParty.post(
      ENV['APPLE_OAUTH_LOGIN_URL'],
      headers: { 'content-type': 'application/x-www-form-urlencoded' },
      query: payload
    ).parsed_response
    return error_in_token if parsed_response['id_token'].nil?

    apple_decode(parsed_response)
  end

  def apple_decode(apple_response)
    decoded = JWT.decode(apple_response['id_token'], nil, false)[0]
    {
      'id' => decoded['email'],
      'email' => decoded['email'],
      'name' => decoded['email'].split("@")[0],
      'gender' => nil,
      'birthday' => nil
    }
  end

  def error_in_token
    { 'error' => { 'message' => t('devise_token_auth.sessions.token_validations') } }
  end
end
