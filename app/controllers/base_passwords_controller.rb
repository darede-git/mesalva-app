# frozen_string_literal: true

require 'me_salva/crm/users'

class BasePasswordsController < DeviseTokenAuth::PasswordsController
  include PasswordValidation
  include AlgoliaIndex
  before_action :set_resource, only: :update
  before_action :invalid_resource?, only: :update
  before_action :valid_params, only: :create
  before_action :set_resource_from_email, only: :create
  skip_after_action :update_auth_header

  def create
    find_intercom_user if @resource.instance_of? User
    if @resource&.save
      update_intercom_user_id if @resource.instance_of? User
      send_reset_password_email
      render_create_success
    else
      render_user_not_found_error
    end
  end

  def update
    if @resource.update_password(params)
      update_algolia_index(@resource) if algolia_attributes?
      render_ok(@resource)
    else
      render_unprocessable_entity(@resource.errors)
    end
  end

  private

  def send_reset_password_email
    @resource.send_reset_password_instructions(email_params)
  end

  def email_params
    if @platform.nil?
      return { email: @email, provider: 'email', redirect_url: @redirect_url,
               client_config: params[:config_name] }
    end

    { email: @email, provider: 'email', redirect_url: @redirect_url,
      client_config: params[:config_name], sender: @sender, from: @sender,
      subject: "Recuperação de Senha - #{@platform.name.titleize}!" }
  end

  def find_intercom_user
    return if Rails.env.test?

    @intercom_user = intercom_client_users.find(user_id: @resource.uid)
  rescue Intercom::ResourceNotFound
    @intercom_user = intercom.create(@resource)
  end

  def update_intercom_user_id
    return if Rails.env.test? || @intercom_user.nil?

    @intercom_user.user_id = @resource.uid
    intercom_client_users.save(@intercom_user)
  rescue Intercom::ResourceNotFound
    intercom.create(@resource)
  rescue Intercom::MultipleMatchingUsersError
    intercom.destroy_duplicated(@resource)
  end

  def intercom
    @intercom ||= MeSalva::Crm::Users.new
  end

  def intercom_client_users
    intercom.client.users
  end

  def render_user_not_found_error
    @errors = [I18n.t('devise_token_auth.passwords.user_not_found',
                      email: @email)]
    @error_status = 400
    render_create_error(@errors)
  end

  def set_resource_from_email
    @email = resource_params[:email].downcase
    @resource = resource_class.find_by_email(@email)
  end

  def valid_params
    return render_create_error_missing_email unless params[:email]

    @redirect_url = redirect_url
    render_create_error_missing_redirect_url unless @redirect_url
  end

  def redirect_url
    return platform_info if params[:platform_slug].present?

    ENV['DEFAULT_URL']
  end

  def platform_info
    @platform = Platform.find_by_slug(params[:platform_slug])
    @sender = "#{@platform.name} - Plataforma MS <#{ENV['MAIL_SENDER']}>"
    "https://#{@platform.domain}"
  end

  def set_resource
    @resource = resource_class.where(reset_password_token: token).take
  end

  def invalid_resource?
    return render_update_error_unauthorized if @resource.nil?

    render_update_error_missing_password if invalid_password?
  end

  def token
    Devise.token_generator.digest(self, :reset_password_token,
                                  resource_params[:reset_password_token])
  end
end
