# frozen_string_literal: true

module CrmEventAssertionHelper
  include CrmEventsParamsHelper

  def assert_last_crm_event_values(event_name, user, **info)
    @event_name = event_name
    @user = user
    @order = info[:order]
    @custom_header = info[:custom_headers]
    @campaign_name = info[:campaign_name]
    @package = package_from(info)
    @education_segment = education_segment_from(info)

    expect(CrmEvent.last.attributes.except('id', 'created_at'))
      .to eq crm_event_attributes
  end

  private

  def crm_event_attributes
    event_attributtes
      .merge(user_info)
      .merge(order_info)
      .merge(system_info)
      .merge(campaign_info)
      .merge(error_message)
      .merge(package_info)
      .merge(ref_data)
      .as_json
  end

  def event_attributtes
    { event_name: @event_name,
      education_segment: education_segment_slug }
  end

  def error_message
    { error_message: nil }
  end

  def education_segment_slug
    return @education_segment.try(:name) if @education_segment
  end

  def order_info
    { order_payment_type: @order.try(:checkout_method),
      order_price: @order.try(:price_paid),
      order_id: @order.try(:id) }
  end

  def user_info
    { user_id: @user.id,
      user_email: @user.email,
      user_name: @user.try(:name),
      user_premium: @user.accesses.any?,
      user_objective: @user.objective.try(:name),
      user_objective_id: @user.objective.try(:id) }
  end

  def system_info
    { location: header('location'),
      ip_address: header('ip-address'),
      client: header('client'),
      device: header('device'),
      user_agent: header('user-agent') }
  end

  def ref_data
    { utm: nil }
  end

  def campaign_info
    { campaign_view_name: @campaign_name }
  end

  def package_info
    { package_name: @package.try(:name),
      package_slug: @package.try(:slug) }
  end

  def header(key)
    @custom_header[key] if @custom_header
  end
end
