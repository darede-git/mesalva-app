DeviseTokenAuth.setup do |config|
  config.default_confirm_success_url = ENV['DEFAULT_URL'] +
                                       ENV['CONFIRM_SUCCESS_URI']
  config.default_password_reset_url = ENV['DEFAULT_URL'] +
                                       ENV['USER_PASSWORD_RESET_URI']
  Devise.allow_unconfirmed_access_for = nil
  Devise.mailer_sender = 'naoresponda@mesalva.com'
  config.change_headers_on_each_request = false
  config.check_current_password_before_update = true
end
