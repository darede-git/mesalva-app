# frozen_string_literal: true

class ResetPasswordsController < ApplicationController
  before_action -> { authenticate(%w[admin]) }
  before_action :set_user

  def reset
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token = hashed
    @user.reset_password_sent_at = Time.now.utc
    @user.save

    render json: { data: { attributes: { token: raw } } }, status: :ok
  end

  def set_user
    @user = User.find_by_uid(params[:user_uid])
    render_unprocessable_entity if @user.nil?
  end
end
