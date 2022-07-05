# frozen_string_literal: true

class User::RegistrationsController < BaseRegistrationsController
  serialization_scope :current_admin
  include SocialLogin
  before_action :set_resources, only: [:create]

  %i[new edit update destroy cancel].each do |action|
    define_method(action) { super }
  end

  def create
    if confirmable_missing_redirect_url? || redirect_url_is_not_whitelisted?
      return render_unprocessable_entity(@resource.errors)
    end

    invalid_social_login
    super
  end

  private

  def set_resources
    @resource = from_origin
    @redirect_url = params[:confirm_success_url]
    @redirect_url ||= DeviseTokenAuth.default_confirm_success_url
  end

  def from_origin
    if social_login?
      User.from_omniauth(auth_hash) if authorized_token?
    else
      return if email_already_in_use?

      sign_up_params.merge(provider: 'email')
      resource_class.new(sign_up_params)
    end
  end

  def email_already_in_use?
    @resource = User.find_by_email(sign_up_params['email'])
    return false unless @resource

    render_unprocessable_entity(t('errors.messages.duplicated_email'))
  end

  def invalid_social_login
    return unless social_login?

    render_unauthorized if unauthorized_token?
    render_malformed_token if malformed_token?
  end

  def render_malformed_token
    render_unprocessable_entity(t('errors.messages.malformed_token'))
  end

  def social_login?
    params['provider'].present?
  end

  def confirmable_missing_redirect_url?
    resource_class.devise_modules.include?(:confirmable) && !@redirect_url
  end

  def redirect_url_is_not_whitelisted?
    DeviseTokenAuth.redirect_whitelist && redirect_url_not_included?
  end

  def redirect_url_not_included?
    DeviseTokenAuth.redirect_whitelist.exclude?(@redirect_url)
  end
end
