# frozen_string_literal: true

class InactivateExpiredAccessesWorker
  include RdStationHelper

  def perform
    Access.active_and_expiring_today.each do |access|
      access.deactivate
      send_rd_station_checkout_event(:expiration_event, access.user, access.package)
      user_transition(access) if access.unique?
    end
  end

  private

  def user_transition(access)
    return access.user.state_machine.transition_to(:ex_subscriber) if subscription?(access)

    access.user.state_machine.transition_to(:unsubscriber)
  end

  def subscription?(access)
    access.order.subscription.present?
  end
end
