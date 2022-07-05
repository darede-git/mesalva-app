# frozen_string_literal: true

class SendEmailChangedWorker
  include Sidekiq::Worker

  def perform(token, platform_slug)
    user = User.find_by_token(token)
    UserMailer.email_changed(user.id, platform_slug).deliver
  end
end
