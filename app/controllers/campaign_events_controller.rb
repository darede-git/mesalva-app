# frozen_string_literal: true

class CampaignEventsController < ApplicationController
  include UtmHelper
  before_action -> { authenticate(%w[user]) }
  before_action :find_inviter_user_by_token, only: :create

  def create
    if invalid_inviter_user?
      return render_unprocessable_entity(t('errors.messages.invalid_inviter'))
    end

    campaign_event = CampaignEvent.new(create_params)

    if campaign_event.save
      render_created(campaign_event)
    else
      render_unprocessable_entity(campaign_event.errors)
    end
  end

  def show_event
    @campaign_event = CampaignEvent.where(campaign_name: params[:campaign_name],
                                          event_name: params[:event_name],
                                          user_id: current_user.id).first
    return render_not_found if @campaign_event.nil?

    response = { 'results' => @campaign_event }
    render json: response, status: :ok
  end

  def count_sequence
    render json: render_show, status: :ok
  end

  private

  def find_inviter_user_by_token
    @inviter_user = User.find_by_token(utm_attr[:utm_content])
  end

  def create_params
    params.permit(:campaign_name,
                  :event_name)
          .merge(invited_by: inviter_user_id,
                 user_id: current_user.id)
  end

  def invalid_inviter_user?
    return false if utm_attr[:utm_content].nil?

    @inviter_user.nil?
  end

  def inviter_user_id
    return nil if @inviter_user.nil?

    @inviter_user.id
  end

  def count_sent_invites
    CampaignEvent.count_sequence(event1: params[:event1],
                                 event2: params[:event2],
                                 invited_by: current_user.id,
                                 campaign_name: params[:campaign_name])
  end

  def render_show
    { 'results' => count_sent_invites }
  end
end
