# frozen_string_literal: true

class UpdateIntercomUserWorker < BaseIntercomUserWorker
  def perform(resource_id, resource_name, attributes = nil)
    begin
      intercom_action('update', resource_id, resource_name, attributes)
    rescue StandardError
      nil
    end
  end
end
