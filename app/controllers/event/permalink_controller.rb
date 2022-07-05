# frozen_string_literal: true

require 'me_salva/event/permalink/query'

class Event::PermalinkController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_permalink_slug

  def show
    return render_not_found if ENV['EVENTS_DISABLE'] == 'true'

    return render_not_found unless grouped_by_item?

    @query = expanded? ? item_events : node_module_events
    return render_not_found if @query.first.nil?

    if lesson_event?
      render json: @query, each_serializer: Event::LessonEventSerializer
    else
      render json: @query,
             serializer: Event::QueryDocumentSerializer,
             adapter: :attributes,
             expanded: params[:expanded],
             group_by: params[:group_by]
    end
  end

  private

  def set_permalink_slug
    @permalink_slug = params[:slug]
  end

  def node_module_events
    node_module = Permalink.find_by_slug(@permalink_slug).node_module
    LessonEvent.module_events(current_user, node_module.slug)
  end

  def item_events
    item = Permalink.find_by_slug(@permalink_slug).item
    return [] if item.nil?

    item_events = ExerciseEvent.where(user: current_user, item_slug: item.slug)
    { results: item_events }
  end

  def grouped_by_item?
    params[:group_by] == 'item'
  end

  def expanded?
    params[:expanded] == 'true'
  end

  def lesson_event?
    !@query.instance_values.present?
  end
end
