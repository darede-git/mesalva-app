# frozen_string_literal: true

module PasswordResetHelper
  extend ActiveSupport::Concern
  def update_password(params)
    update_attributes(params.permit(:password, :password_confirmation))
  end
end
