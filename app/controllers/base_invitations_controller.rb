# frozen_string_literal: true

class BaseInvitationsController < Devise::InvitationsController
  include PasswordValidation
  include AlgoliaIndex
  abstract!
  before_action :validate_password, only: :update
  before_action :resource_from_invitation_token, only: :update
  before_action -> { authenticate(%w[admin]) }, only: :create
  after_action :update_auth_headers, only: :create

  def create
    if new_invitation?
      resource = resource_class.invite!(invite_params, current_admin)
      render_created(resource)
    else
      render_unprocessable_entity(t('devise.invitations.duplicated_invitation'))
    end
  end

  def update
    @resource = resource_class
                .accept_invitation!(invitation_token: params[:invitation_token],
                                    password: params[:password])
    if @resource
      update_algolia_index(@resource) if algolia_attributes?
      render_accepted
    else
      render_unprocessable_entity(@resource.errors)
    end
  end

  private

  def new_invitation?
    return true unless resource_class.find_by_email(params[:email])

    false
  end

  def resource_class(map = nil)
    mapping = if map
                Devise.mappings[map]
              else
                Devise.mappings[resource_name] || Devise.mappings.values.first
              end
    mapping.to
  end

  def validate_password
    return unless invalid_password?

    render_unprocessable_entity(
      t('devise_token_auth.passwords.invalid_password')
    )
  end

  def invite_params
    params.permit(:name, :email, :invitation_token)
  end

  def accept_invitation_params
    params.permit(:password, :password_confirmation, :invitation_token)
  end

  def authenticate_inviter!; end

  def resource_from_invitation_token
    if params[:invitation_token]
      @resource = resource_class.where(invitation_token: token)
                                .take
    end
    return @resource if @resource

    render_unauthorized
  end

  def token
    Devise.token_generator.digest(self, :invitation_token,
                                  params[:invitation_token])
  end
end
