# frozen_string_literal: true

require 'me_salva/event/permalink/query'

class EventsController < ApplicationController
  include ResponseHelper
  include UtmHelper
  include PermalinkEntities
  include PermalinkEventHelper
  include PermalinkAuthorization

  before_action -> { authenticate(%w[user]) }
  before_action :set_permalink, only: :create
  before_action :update_user_last_modules, only: :create

  def create
    create_event(event_params[:event_name])
    render_permalink(event_details)
  end

  private

  def event_params
    params.permit(:slug, :answer_id, :event_name, :rating, :submission_token,
                  :source_name, :source_id)
  end

  def render_permalink(meta)
    render json: @permalink, serializer: Permalink::PermalinkSerializer,
           meta: meta, status: :ok
  end

  def event_details
    return unless @permalink.ends_with_exercise_medium?

    { answer_id: @permalink.medium_correct_answer_id,
      correction: @permalink.medium.correction }
  end

  def set_permalink
    @permalink = Permalink.find_by_slug(params[:slug])
    return render_not_found unless @permalink
  end
end
