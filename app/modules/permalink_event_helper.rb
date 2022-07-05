# frozen_string_literal: true

module PermalinkEventHelper
  extend ActiveSupport::Concern

  def create_event(event_name)
    permalink_event = create_exercise_event(event_name)
    create_lesson_event(permalink_event)
    return true unless intercom_event?(event_name)

    create_intercom_event(event_name)
  end

  def create_exercise_event(event_name)
    data = permalink_event_params.merge(event_name: event_name)
    return nil unless permalink_data_valid?

    permalink_event = PermalinkEvent.create!(data)
    ExerciseEvent.create(exercise_event_params(permalink_event)) if permalink_event.permalink_answer_id.present?
    permalink_event
  end

  def append_prep_test_event(event_name, correct)
    data = permalink_event_params.merge(event_name: event_name)
    return nil unless permalink_data_valid?

    @permalink_events ||= []
    @permalink_events << data

    @exercise_events ||= []
    @exercise_events << exercise_event_params_from_data(data, correct) if data[:permalink_answer_id].present?
  end

  def create_appended_prep_test_events
    entity_slugs = @permalink.slug.split('/').last(3)
    PermalinkEvent.create!(@permalink_events)
    ExerciseEvent.create!(@exercise_events)
    LessonEvent.create({ node_module_slug: entity_slugs.first, item_slug: entity_slugs.second,
                         submission_token: submission_token, user: current_user })
  end

  def permalink_data_valid?
    @permalink.node_module_id.present? &&
      @permalink.item_id.present? &&
      @permalink.medium_id.present?
  end

  def create_lesson_event(permalink_event)
    return nil if permalink_event.nil?

    LessonEvent.create(lesson_event_params(permalink_event))
  end

  private

  def lesson_event_params(permalink_event)
    { node_module_slug: permalink_event.permalink_node_module_slug,
      item_slug: permalink_event.permalink_item_slug,
      submission_token: permalink_event.submission_token,
      user: current_user }
  end

  def exercise_event_params(permalink_event)
    { item_slug: permalink_event.permalink_item_slug,
      medium_slug: permalink_event.permalink_medium_slug,
      answer_id: permalink_event.permalink_answer_id,
      correct: permalink_event.permalink_answer_correct,
      submission_token: permalink_event.submission_token,
      user: current_user }
  end

  def exercise_event_params_from_data(data, correct)
    { item_slug: data[:permalink_item_slug],
      medium_slug: data[:permalink_medium_slug],
      answer_id: data[:permalink_answer_id],
      correct: correct,
      submission_token: data[:submission_token],
      user: current_user }
  end

  def create_intercom_event(event_name)
    CreateIntercomEventWorker.perform_async([event_name(event_name),
                                             current_user.uid,
                                             intercom_params])
  end

  def event_name(event_name)
    return content_rate_name if event_name == PermalinkEvent::CONTENT_RATE

    "#{event_name}_#{request_header('client').try(:downcase)}"
  end

  def content_rate_name
    return 'content_rate_neutral' if event_params[:rating].to_i == 3
    return 'content_rate_negative' if event_params[:rating].to_i <= 2

    'content_rate_positive'
  end

  def intercom_event?(event_name)
    PermalinkEvent::INTERCOM_EVENTS.include? event_name
  end

  def permalink_event_params
    permalink_data.merge(user_data)
                  .merge(request_headers_data)
                  .merge(utm: utm_attr)
  end

  def intercom_params
    permalink_data.merge(user_data)
                  .merge(request_headers_data)
                  .merge(utm_attr)
  end

  def user_data
    return empty_user_data unless current_user

    { user_id: current_user.id, user_email: current_user.email,
      user_name: current_user.name, user_premium: user_premium?,
      user_objective: current_user.objective.try(:name),
      user_objective_id: current_user.objective_id }
  end

  def user_premium?
    current_user.premium?
  end

  def empty_user_data
    { user_id: '', user_email: '', user_name: '', user_premium: '' }
  end

  def permalink_data
    { permalink_slug: @permalink.slug }
      .merge(permalink_node_data)
      .merge(permalink_entity_data('node_module'))
      .merge(permalink_entity_data('item'))
      .merge(permalink_entity_data('medium'))
      .merge(permalink_relation_answers)
      .merge(content_rating_data)
      .merge(source_attr)
  end

  def action_name_show?
    action_name == 'show'
  end

  def permalink_entity_data(entity)
    {}.tap do |hash|
      hash[:"permalink_#{entity}"] = @permalink.send(entity).try(:name)
      hash[:"permalink_#{entity}_id"] = @permalink.send(entity).try(:id)
      unless entity == 'node_module'
        hash[:"permalink_#{entity}_type"] = @permalink.send(entity).try("#{entity}_type")
      end
      hash[:"permalink_#{entity}_slug"] = @permalink.send(entity).try(:slug)
    end
  end

  def permalink_node_data
    permalink_nodes_attributes.merge(permalink_node_id: @permalink.node_ids)
  end

  def permalink_relation_answers
    { permalink_answer_id: event_params[:answer_id],
      permalink_answer_correct: correct_answer?,
      submission_at: event_params[:submission_at],
      submission_token: event_params[:submission_token],
      starts_at: event_params[:starts_at] }
  end

  def content_rating_data
    { content_rating: (event_params[:rating] if rate_action?) }
  end

  def source_attr
    { source_name: event_params[:source_name],
      source_id: event_params[:source_id] }
  end

  def empty_permalink_answer
    { permalink_answer_id: nil, permalink_answer_correct: nil }
  end

  def permalink_nodes_attributes
    { permalink_node: @permalink.nodes.map(&:name),
      permalink_node_slug: @permalink.nodes.map(&:slug),
      permalink_node_type: @permalink.nodes.map(&:node_type) }
  end

  def request_headers_data
    request_headers = { user_agent: request_header('user-agent') }
    %i[location client device].each do |header|
      request_headers[header] = request_header(header)
    end
    request_headers
  end

  def request_header(key)
    request.headers[key]
  end

  def correct_answer?
    @permalink.medium_correct_answer?(event_params[:answer_id])
  end

  def update_user_last_modules
    return unless current_user

    UpdateUserLastModulesCacheWorker
      .perform_async(current_user.id, @permalink.id)
  end

  def education_segment_slug
    @permalink.education_segment_slug
  end
end
