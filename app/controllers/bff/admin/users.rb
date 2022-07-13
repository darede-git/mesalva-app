# frozen_string_literal: true

class Bff::Admin::Users < Bff::Admin::BffAdminBaseController
  PAID_ORDER_STATUS = [2, 6, 8].freeze

  def anonymize_user
    @student = User.find_by_uid(params['uid'])
    return render_has_order_history_error if order_history?

    anonymize_all_user_data
  end

  private

  def render_has_order_history_error
    render_unprocessable_entity(t('activerecord.errors.models.user.has_order_history'))
  end

  def order_history?
    @student.orders.where(status: PAID_ORDER_STATUS).exists?
  end

  def anonymize_all_user_data
    update_data_user
    update_data_crm_event
    update_data_order
    render_no_content
  end

  def update_data_user
    update_data_address(@student.address)
    @student.name = "Erased User #{date_now}"
    @student.uid = email_erased
    @student.email = email_erased
    @student.crm_email = email_erased
    @student.save
  end

  def email_erased
    "erased-user-#{date_now}@mesalva.org".gsub(' ', '')
  end

  def update_data_crm_event
    crm = CrmEvent.find_by_user_id(@student.id)
    crm.ip_address = '000.000.000.000'
    crm.user_email = email_erased
    crm.user_name = "Erased User #{date_now}"
    crm.save
  end

  def update_data_order
    @student.orders.each do |order|
      update_data_address(order.address) if order.address.present?
      order.email = email_erased
      order.cpf = '00000000000'
      order.phone_number = '000000000'
      order.phone_area = '00'
      order.save
    end
  end

  def update_data_address(address)
    address.street = 'Erased'
    address.street_number = 0
    address.street_detail = 'Erased'
    address.neighborhood = 'Erased'
    address.city = 'Erased'
    address.zip_code = '00000-000'
    address.state = 'Erased'
    address.area_code = '00'
    address.phone_number = '000000000'
    address.save
  end

  def date_now
    DateTime.now.strftime('%Y-%m-%d_%H:%M')
  end
end
