# frozen_string_literal: true

class BaseSessionsController < DeviseTokenAuth::SessionsController
  abstract!
  include SerializationHelper
  include UtmHelper
  include IntercomHelper
  include CrmEvents
  include AlgoliaIndex
  include Authorization
  before_action :configure_sign_in_params, only: %i[create destroy]
  skip_after_action :update_auth_headers, raise: false

  def create
    return success if authenticable_resource?
    return render_unauthorized if unauthenticable_resource?

    bad_credentials
  rescue BCrypt::Errors::InvalidHash
    render_unprocessable_entity(t('errors.messages.invalid_hash'))
  end

  def destroy
    if valid_resource_token
      @resource.tokens.delete(request_header_client)
      @resource.save!
      remove_resources
      render_no_content
    else
      render_not_found
    end
  end

  private

  def track_user
    @resource.update_tracked_fields!(request) if @resource&.valid?
  end

  def valid_resource_token
    @resource && request_header_client &&
      @resource.tokens[request_header_client]
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end

  def success
    track_user
    update_intercom if intercom_resource?
    create_sign_event if @resource.instance_of? User
    begin
      update_auth_headers(params[:platform_slug])
      render json: @resource,
             include: %i[education_level objective],
             status: :accepted
    rescue Exception=> e
      return render_default_error(e.message, :not_found)
    end
  end

  def create_sign_event
    return create_sign_up_event if first_social_login?

    create_crm('login', @resource)
    update_intercom
  end

  def first_social_login?
    @resource.sign_in_count == 1
  end

  def create_sign_up_event
    PersistCrmEventWorker.perform_async(crm_sign_up_params)
    create_intercom_user(@resource, intercom_attributes)
    CrmRdstationSignupEventWorker.perform_async(@resource.uid,
                                                request_header_client)
  end

  def intercom_attributes
    { subscriber: User::PREMIUM_STATUS[:student_lead],
      client: request.headers['client'] }.merge(utm_attr)
  end

  def not_confirmed
    render json: {
      success: false,
      errors: [I18n.t('devise_token_auth.sessions.not_confirmed',
                      email: @resource.email)]
    }, status: :unauthorized
  end

  def bad_credentials
    render json: {
      errors: [I18n.t('devise_token_auth.sessions.bad_credentials')]
    }, status: :unauthorized
  end

  def authenticable_resource?
    @resource && params_valid? && active_for_authentication?
  end

  def unauthenticable_resource?
    @resource && !active_for_authentication?
  end

  def params_valid?
    valid_params?(:email, resource_params[:email]) &&
      @resource.valid_password?(resource_params[:password])
  end

  def active_for_authentication?
    (!@resource.respond_to?(:active_for_authentication?) ||
      @resource.active_for_authentication?)
  end

  def remove_resources
    @resource, @client_id, @token = nil
  end

  def crm_sign_up_params
    crm_event_params('sign_up', @resource)
  end

  def request_header_client
    request.headers['client']
  end
end
