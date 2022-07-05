# frozen_string_literal: true

class User::EmailChangeController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[user admin]) }

  def create
    if valid_create_params
      return render_unauthorized unless current_user.valid_password?(params['password'])

      create_email_change

      SendEmailChangedWorker.perform_async(current_user.token, @platform&.slug)
      head :ok
    else
      render_unprocessable_entity
    end
  end

  def confirm
    if valid_confirm_params
      confirm_email_change
      head :ok
    else
      render_unauthorized
    end
  end

  private

  def valid_create_params
    params.include?('new_email') && params.include?('password')
  end

  def valid_confirm_params
    return false unless params.include?('token')
    return false unless current_user.options['new-email-token'] == params['token']

    true
  end

  def create_email_change
    current_user.options['new-email'] = params['new_email']
    current_user.options['new-email-token'], = Devise.token_generator.generate(User, :email)
    current_user.save
  end

  def confirm_email_change
    update_crm_contacts
    current_user.update(email: current_user.options['new-email'])
    current_user.confirm
  end

  def update_crm_contacts
    rd_user = MeSalva::Crm::Rdstation::Users.new(current_user)
    rd_user.update_attribute('email', current_user.options['new-email'])
    updated_user = current_user
    updated_user.email = updated_user.options['new-email']
    MeSalva::Crm::Users.new.update(updated_user)
  end
end
