# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  # rubocop:disable Naming/AccessorMethodName
  def set_user_by_token(mapping = nil)
    return nil unless client_name

    uid = request.headers['uid']
    access_token = header_access_token

    return false unless access_token || uid || @client_id

    rc = resource_class(mapping)
    user = uid && rc.find_by_uid(uid)

    @resource = sign_in_resource(user, access_token, @client_id)
  end
  # rubocop:enable Naming/AccessorMethodName

  def create_new_auth_token(platform = nil)
    @authentication_platform = platform if platform.present?
    @client_id ||= client_name
    return nil unless @client_id

    token = SecureRandom.urlsafe_base64(nil, false)
    token_hash = ::BCrypt::Password.create(token)
    expiry = time_to_token_expiry

    @resource.tokens[@client_id] = { token: token_hash,
                                     expiry: expiry,
                                     last_token: actual_token,
                                     platform_id: @authentication_platform&.id,
                                     platform_slug: @authentication_platform&.slug,
                                     updated_at: Time.now }
    @resource.save
    @resource.build_auth_header(token, @client_id)
  end

  def current_platform
    return @resource_platform unless @resource_platform.nil?

    return nil unless resource_token_platform_id?

    platform_id = current_user.tokens[@client_id]['platform_id']
    @resource_platform = Platform.find(platform_id)
  end

  def current_user_platform
    return nil unless current_platform

    @resourse_user_platform = UserPlatform.where(platform: current_platform,
                                                 user: current_user).take
  end

  def super_admin?
    return false if current_user_platform.nil?

    return true if current_platform.slug == 'admin' && current_user_platform.role == 'admin'

    UserPlatform.joins(:platform)
                .where({ "platforms.slug": 'admin', "user_platforms.user_id": current_user.id })
                .count
                .positive?
  end

  def platform_id
    return @sign_platform.id if @sign_platform.present?

    return @resource.tokens[@client_id]['platform_id'] if resource_token_platform_id?

    @platform&.id
  end

  def resource_token_platform_id?
    current_user.tokens && current_user.tokens[@client_id] && current_user.tokens[@client_id]['platform_id']
  end

  def update_auth_headers(platform_slug = nil)
    return nil unless client_name

    @resource ||= find_resource_to_authorize
    unless platform_slug.blank?
      @authentication_platform = Platform.find_signin_user(@resource.id, platform_slug)
      raise t('errors.messages.user_platform_not_found') if @authentication_platform.nil?
    end
    return render_impersonation_resource if impersonation_action?

    @access_token = header_access_token
    return nil unless @resource.try(:valid?)

    @token = actual_token

    return merge_into_headers(render_same_token) if valid_token?

    merge_into_headers(create_new_auth_token)
  end

  def merge_into_headers(auth_headers)
    response.headers.merge!(auth_headers)
  end

  def render_impersonation_resource
    @resource = User.find_by_uid(params[:uid])
    @sign_platform = User.find_by_uid(params[:platform_slug]) if params[:platform_slug].present?
    response.headers.merge!(create_new_auth_token)
  end

  def impersonation_action?
    controller_name == 'impersonations'
  end

  def resource_class(map = nil)
    return Devise.mappings[map].to if map

    Devise.mappings[resource_name].to || Devise.mappings.values.first.to
  end

  def sign_in_resource(user, access_token, client)
    return user if user&.valid_token?(access_token, client)

    user if development_debug_request?
  end

  def render_same_token
    @resource.tokens[@client_id]['token'] = BCrypt::Password.create(@access_token)
    @resource.tokens[@client_id]['expiry'] = time_to_token_expiry
    @resource.save
    @resource.build_auth_header(@access_token, @client_id)
  end

  def time_to_token_expiry
    (Time.now + DeviseTokenAuth.token_lifespan).to_i
  end

  def header_access_token
    request.headers['access-token']
  end

  def client_name
    @client_id = request.headers['client']
    return unless @client_id

    @client_id if valid_client_id?(@client_id)
  end

  def actual_token
    @resource.tokens[@client_id]['token'] if @resource
                                             .tokens[@client_id]
                                             .present?
  end

  def find_resource_to_authorize
    resource = current_resource
    return resource if resource.present?

    resource_from_invitation_token if devise_controller?
  end

  def current_resource
    %w[user admin teacher].collect do |resource|
      # rubocop: disable Style/DocumentDynamicEvalDefinition
      # rubocop: disable Style/EvalWithLocation
      instance_eval "current_#{resource}" if resource_present?(resource)
      # rubocop: enable Style/DocumentDynamicEvalDefinition
      # rubocop: enable Style/EvalWithLocation
    end.compact!.first
  end

  def resource_present?(resource)
    # rubocop: disable Style/DocumentDynamicEvalDefinition
    # rubocop: disable Style/EvalWithLocation
    instance_eval "#{resource}_signed_in?"
    # rubocop: enable Style/DocumentDynamicEvalDefinition
    # rubocop: enable Style/EvalWithLocation
  end

  def valid_token?
    return false unless @access_token

    valid_expire_token? && BCrypt::Password.new(@token) == @access_token
  end

  def valid_expire_token?
    return false unless @resource.tokens[@client_id].present? &&
                        @resource.tokens[@client_id]['expiry'].present?

    expiry_time = Time.at(@resource.tokens[@client_id]['expiry'])
    expiry_time > Time.now
  end

  def valid_client_id?(client_id)
    return true if client_id == 'DEBUG'

    ENV['CLIENT_WHITELIST'].split.include?(client_id)
  end
end
