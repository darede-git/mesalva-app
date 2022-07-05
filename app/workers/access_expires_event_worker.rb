# frozen_string_literal: true

class AccessExpiresEventWorker
  include Sidekiq::Worker
  include IntercomHelper
  include UtmHelper
  include CrmEvents
  include RdStationHelper

  def perform
    access_expires = MeSalva::Crm::AccessExpires.new
    access_expires.event_expire_access(0)
    access_expires.event_expire_access(30)
  end
end
