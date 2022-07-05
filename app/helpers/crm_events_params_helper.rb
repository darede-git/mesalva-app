# frozen_string_literal: true

module CrmEventsParamsHelper
  include UtmHelper

  def crm_event_params(event_name, user, **info)
    @event_name = event_name
    @user = user
    @order = info[:order]
    @package = package_from(info)
    @ip_address = user.current_sign_in_ip
    @education_segment = education_segment_from(info)
    @error_message = info[:error_message]

    crm_params
  end

  def intercom_params
    user_info
      .merge(order_data)
      .merge(education_segment_name)
      .merge!(system_info)
      .merge!(utm_attr)
  end

  private

  def crm_params
    event_data
      .merge(user_info)
      .merge(order_data)
      .merge(package_data)
      .merge(education_segment_name)
      .merge!(system_info)
      .merge(utm_attributes: utm_attr)
  end

  def event_data
    { event_name: @event_name }
  end

  def user_info
    { user_id: @user.id,
      user_email: @user.email,
      user_name: @user.try(:name),
      user_premium: user_premium?,
      user_objective: @user.objective_name,
      user_objective_id: @user.try(:objective).try(:id) }
  end

  def order_data
    { order_payment_type: @order.try(:checkout_method),
      order_price: @order.try(:price_paid),
      order_id: @order.try(:id) }
  end

  def package_data
    { package_name: @package.try(:name),
      package_slug: @package.try(:slug) }
  end

  def education_segment_name
    { education_segment: @education_segment.try(:name) }
  end

  def system_info
    { location: request_header('location'),
      ip_address: @ip_address,
      client: request_header('client'),
      device: request_header('device'),
      user_agent: request_header('user-agent') }
  end

  def user_premium?
    @user.accesses.any?
  end

  def education_segment_from(**info)
    Node.find_by_slug(event_education_segment_slug(info))
  end

  def package_from(**info)
    return info[:package] if info[:package]

    info[:order].try(:package)
  end

  def event_education_segment_slug(**info)
    info[:education_segment_slug] || @package.try(:education_segment_slug)
  end
end
