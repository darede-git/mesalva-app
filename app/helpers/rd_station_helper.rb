# frozen_string_literal: true

module RdStationHelper
  def send_rd_station_event(**params)
    MeSalva::Crm::Rdstation::Event::Sender.new(params).send_event
  end

  def valid_checkout_event_client(client_type)
    %i[client ex_client repurchase_client upsell_client].include?(client_type)
  end

  def valid_payment_bank_slip_status(status)
    %i[generated expires_today expired].include?(status)
  end

  def send_rd_station_checkout_event(event_type, user, package)
    client_type = MeSalva::User::PremiumStatusValidator.new(user).rd_status(event_type)
    params = { event: rdstation_event_name('checkout', client_type),
               params: { user: user,
                         package: package } }
    send_rd_station_event(params) if valid_checkout_event_client(client_type)
  end

  def send_rd_station_payment_bankslip_event(event_type, order)
    bank_slip_status = :generated
    params = { event: rdstation_event_name('payment_bank_slip', bank_slip_status),
               params: { order: order } }
    send_rd_station_event(params) if valid_payment_bank_slip_status(bank_slip_status)
  end

  def rdstation_event_name(class_name, detail)
    "#{class_name}_#{detail}".to_sym
  end
end
