# frozen_string_literal: true

module PasswordValidation
  extend ActiveSupport::Concern
  def invalid_password?
    nil_password? || blank_password? || invalid_password_length?
  end

  def blank_password?
    params[:password].empty? || params[:password_confirmation].empty?
  end

  def nil_password?
    params[:password].nil? || params[:password_confirmation].nil?
  end

  def invalid_password_length?
    params[:password].length < 6 || params[:password_confirmation].length < 6
  end
end
