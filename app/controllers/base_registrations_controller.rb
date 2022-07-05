# frozen_string_literal: true

class BaseRegistrationsController < DeviseTokenAuth::RegistrationsController
  abstract!
  include SerializationHelper
  include IntercomHelper
  include CrmEvents
  include UtmHelper
  include AlgoliaIndex

  before_action :configure_sign_up_params, only: [:create]

  def create
    if @resource.save
      track_user
      create_events
      send_confirmation_email if email_informed_and_not_confirmed?
      update_algolia_index(@resource) if algolia_attributes?
      update_auth_headers
      render_success
    else
      clean_up_passwords @resource
      render_unprocessable_entity(@resource.errors)
    end
  end

  def send_confirmation_email
    SendConfirmationWorker.perform_async(token: @resource.token,
                                         client_config: params[:config_name],
                                         redirect_url: @redirect_url)
  end

  def email_informed_and_not_confirmed?
    @resource.email.present? && !@resource.confirmed?
  end

  def track_user
    @resource.update_tracked_fields!(request) if @resource&.valid?
  end

  def create_events
    return unless @resource.instance_of? User

    create_intercom_user(@resource, intercom_attributes)
    create_sign_up_event if @resource.sign_in_count == 1
  end

  def intercom_attributes
    { subscriber: User::PREMIUM_STATUS[:student_lead],
      client: request.headers['client'] }.merge(utm_attr)
  end

  def create_sign_up_event
    PersistCrmEventWorker.perform_async(crm_sign_up_params)
    CrmRdstationSignupEventWorker.perform_async(@resource.uid,
                                                request.headers['client'])
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name
                                                         phone_area
                                                         phone_number])
  end

  def render_success
    update_auth_headers
    render_created(@resource)
  end

  def crm_sign_up_params
    crm_event_params('sign_up', @resource)
  end
end
