# frozen_string_literal: true

class CreateIntercomUserWorker < BaseIntercomUserWorker
  def perform(resource_id, resource_name, attributes = nil)
    intercom_action('create', resource_id, resource_name, attributes)
  end
end
