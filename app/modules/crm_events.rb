# frozen_string_literal: true

module CrmEvents
  extend ActiveSupport::Concern
  include CrmEventsParamsHelper
  include IntercomHelper

  def create_crm(event_name, user, order = false, message = false)
    event_attributes = crm_event_params(event_name, user, order: order)
    event_attributes[:error_message] = message if message
    PersistCrmEventWorker.perform_async(event_attributes)
    create_intercom_event(event_name, user, intercom_params)
  end
end
