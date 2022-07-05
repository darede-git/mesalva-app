# frozen_string_literal: true

class CrmRdstationObjectiveChangeEventWorker
  include Sidekiq::Worker
  include RdStationHelper

  def perform(user_uid, objective_id)
    user = ::User.find_by_uid(user_uid)
    send_rd_station_event(event: :study_objective_change,
                          params: { user: user,
                                    objective_id: objective_id })
  end
end
