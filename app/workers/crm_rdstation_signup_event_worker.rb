# frozen_string_literal: true

class CrmRdstationSignupEventWorker
  include Sidekiq::Worker
  include RdStationHelper

  def perform(user_uid, client = 'WEB')
    return if ENV['RDSTATION_ACTIVE'] == 'false'

    user = ::User.find_by_uid(user_uid)
    send_rd_station_event(event: :sign_up, params: { user: user, client: client })
  end
end
