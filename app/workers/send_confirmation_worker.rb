# frozen_string_literal: true

class SendConfirmationWorker
  include Sidekiq::Worker

  def perform(params)
    @resource = User.find_by_token(params[:token])
    @resource.send_confirmation_instructions(
      client_config: params[:config_name],
      redirect_url: params[:redirect_url]
    )
  end
end
