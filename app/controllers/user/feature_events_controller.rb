# frozen_string_literal: true

class User::FeatureEventsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :event_params

  def create
    if persisted?
      render json: response_for(event), status: :created
    else
      render_unprocessable_entity
    end
  end

  def show
    if event
      render json: response_for(event), status: :ok
    else
      render_not_found
    end
  end

  def index
    if events
      render json: response_for(events), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    remove_module
    if @event
      render json: response_for(events), status: :ok
    else
      render_not_found
    end
  end

  private

  def response_for(object)
    type = 'week' if week_event?
    type ||= 'next'
    {
      data: {
        id: current_user.uid,
        type: type,
        attributes: object
      }
    }
  end

  def persisted?
    return append if list_event?

    redis.set(event_key, event_params['module']) == 'OK'
  end

  def remove_module
    remove_from_list if already_listed?
  end

  def event
    return @event ||= last_event if list_event?

    json = redis.get(event_key)
    return unless json

    @event ||= instance_eval(json)
  end

  def event_key
    "#{feature}.#{section}.#{current_user.uid}.#{context}"
  end

  def week_event?
    context.match('week').present?
  end

  def list_event?
    feature == 'syllabus' && week_event?
  end

  def last_event
    redis.lindex(event_key, redis.llen(event_key) - 1)
  end

  def events
    modules = redis.lrange(event_key, 0, - 1)
    @events ||= { 'modules' => modules }
  end

  def append
    return @event = event_params['module'] if already_listed?

    saved = redis.rpush(event_key, event_params['module']['slug']).is_a? Integer
    @event = event_params['module'] if saved
  end

  def remove_from_list
    removed = redis.lrem(event_key, 0, params[:id]).is_a? Integer
    @event = events if removed
  end

  def already_listed?
    redis.lrange(event_key, 0, -1).include?(event_params['module']['slug'])
  end

  def event_params
    params.permit(:feature, :section, :context, module: {}).to_hash
  end

  %w[feature section context].each do |param|
    define_method(param) { params[param] }
  end

  def redis
    Redis.current
  end
end
