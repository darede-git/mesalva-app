# frozen_string_literal: true

require 'me_salva/crm/users'
require 'me_salva/crm/events'

module IntercomHelper
  def create_intercom_event(event_name, user, **metadata)
    return if ENV['INTERCOM_ACTIVE'] == 'false'

    CreateIntercomEventWorker.perform_async([event_name, user.uid, metadata])
  end

  def create_intercom_user(resource, **attributes)
    return if ENV['INTERCOM_ACTIVE'] == 'false'

    CreateIntercomUserWorker.perform_async(resource.id,
                                           resource.class,
                                           attributes.to_a)
  end

  def update_intercom_user(resource, **attributes)
    return if ENV['INTERCOM_ACTIVE'] == 'false'

    UpdateIntercomUserWorker.perform_async(resource.id,
                                           resource.class,
                                           attributes.to_a)
  end

  def destroy_intercom_user(resource)
    return if ENV['INTERCOM_ACTIVE'] == 'false'

    DestroyIntercomUserWorker.perform_async(resource.id, resource.class)
  end

  def update_intercom
    update_intercom_user(@resource,
                         { client: request_header_client }.merge(utm_attr))
  end

  def intercom_resource?
    %w[User].include? @resource.class.to_s
  end
end
