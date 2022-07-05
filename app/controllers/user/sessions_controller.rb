# frozen_string_literal: true

class User::SessionsController < BaseSessionsController
  serialization_scope :current_admin
  include SocialLogin
  include Authorization
  include RdStationHelper
  before_action :validate_client, only: :cross_platform
  before_action -> { authenticate(%w[user]) }, only: :cross_platform
  before_action :set_resource, exept: :destroy

  def create
    return super unless social_login?

    return success if social_without_errors? && client_name

    return render_unauthorized if unauthorized_token?

    return render_unprocessable_entity(t('errors.messages.malformed_token')) if malformed_token?

    render_unprocessable_entity(t('devise_token_auth.sessions.bad_credentials'))
  end

  def destroy
    super
  end

  def cross_platform
    @client_id = platform
    render json: create_new_auth_token, status: :ok
  end

  private

  def set_resource
    @resource = if create_action?
                  from_origin
                else
                  current_user
                end
  end

  def from_origin
    if social_login?
      User.from_omniauth(auth_hash) if authorized_token? && auth_hash
    else
      User.find_for_authentication(email: resource_params[:email])
    end
  end

  def social_login?
    valid_provider?
  end

  def social_without_errors?
    resource_without_errors
  end

  def resource_without_errors
    @resource.try(:errors).try(:empty?)
  end

  def success
    update_algolia_index(@resource)
    send_rd_station_event(event: :sign_in,
                          params: { user: @resource,
                                    client: request.headers['client'] })
    super
  end

  def create_action?
    params[:action] == 'create'
  end

  def validate_client
    return if valid_client?

    render_unprocessable_entity(I18n.t('errors.messages.invalid_platform'))
  end

  def platform
    params[:platform]
  end

  def valid_client?
    return false if request.headers['client'] == platform

    valid_client_id?(platform)
  end
end
