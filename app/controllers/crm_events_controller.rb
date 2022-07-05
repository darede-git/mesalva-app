# frozen_string_literal: true

class CrmEventsController < ApplicationController
  include IntercomHelper
  include UtmHelper
  include CrmEventsParamsHelper
  include RdStationHelper

  before_action -> { authenticate(%w[user]) }

  def create
    @crm_event = CrmEvent.new(crm_attributes)

    if valid_event? && @crm_event.save
      intercom_action
      send_rd_station_event(event: event_name.to_sym,
                            params: { user: current_user,
                                      campaign_name: campaign_name_param,
                                      package: package })
      schedule_chat_guru_message if checkout_view?
      render_no_content
    else
      render_unprocessable_entity(@crm_event.errors)
    end
  end

  private

  def schedule_chat_guru_message  
      ChatGuruWorker.perform_in(10.minutes, current_user.uid)
  end

  def intercom_action
    return update_campaign_intercom_attribute if campaign_view?

    create_intercom_event(event_name, current_user, intercom_params)
  end

  def crm_attributes
    crm_event_params(event_name,
                     current_user,
                     package: package,
                     education_segment_slug: education_segment_slug)
      .merge(campaign_view_name: campaign_name_param)
  end

  def package
    @package ||= Package.find(params['package_id']) if params['package_id']
  end

  def education_segment
    Node.find_by_slug(education_segment_slug)
  end

  def valid_event?
    return true if event_whitelist.include?(event_name) &&
                   (package ||
                    education_segment ||
                    campaign_name_param)

    @crm_event.errors.add(:message, t('events.invalid_params'))
    false
  end

  def update_campaign_intercom_attribute
    update_intercom_user(current_user, campaign_name: campaign_name_param)
  end

  def campaign_name_param
    params['campaign_name']
  end

  def education_segment_slug
    params['education_segment_slug']
  end

  def campaign_view?
    event_name == 'campaign_view'
  end

  def checkout_view?
    event_name == 'checkout_view'
  end

  def event_name
    request.headers['event-name']
  end

  def event_whitelist
    %w[plans_view
       checkout_view
       checkout_fail
       campaign_view
       campaign_sign_up].freeze
  end
end
