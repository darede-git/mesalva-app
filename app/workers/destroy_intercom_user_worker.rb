# frozen_string_literal: true

class DestroyIntercomUserWorker < BaseIntercomUserWorker
  def perform(resource_id, resource_name)
    intercom_action('destroy', resource_id, resource_name)
  end
end
