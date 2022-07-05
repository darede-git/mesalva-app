# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

module PermalinkEventAssertionHelper
  def assert_update_user_last_modules_worker_call(called)
    if called
      expect(UpdateUserLastModulesCacheWorker)
        .to receive(:perform_async).with(user.id, complete_permalink.id)
    else
      expect(UpdateUserLastModulesCacheWorker)
        .not_to receive(:perform_async).with(any_args)
    end
  end

  def assert_create_intercom_worker_call(**options)
    create_instance_vars(options)
    assert_event_name
    assert_allowed_crm_event
    expect(CreateIntercomEventWorker).to receive(:perform_async)
      .with([event_name, user.uid, intercom_attributes.symbolize_keys])
  end

  def assert_allowed_crm_event
    expect(MeSalva::Crm::Events.allowed_event?(event_name)).to be true
  end

  def assert_create_worker_is_not_called(worker_name)
    expect("Create#{worker_name}EventWorker".constantize)
      .not_to receive(:perform_async).with(any_args)
  end

  private

  def event_name
    return content_rate_name if @event_name == 'content_rate'

    "#{@event_name}_#{request.headers['client'].downcase}".to_s
  end

  def content_rate_name
    return 'content_rate_neutral' if @rating.to_i == 3

    return 'content_rate_negative' if @rating.to_i <= 2

    'content_rate_positive'
  end

  def create_instance_vars(vars)
    vars.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def assert_event_name
    expect(PermalinkEvent::ALLOWED_EVENT_NAMES).to include @event_name
  end

  def event_attributes
    permalink_data.merge(user_data).merge(request_data)
                  .merge(utm_attributes: utm_data).as_json
  end

  def intercom_attributes
    permalink_data.merge(user_data).merge(request_data)
                  .merge(utm_data).as_json
  end

  def request_data
    { user_agent: @custom_headers['user-agent'],
      location: @custom_headers['location'],
      client: @custom_headers['client'], device: @custom_headers['device'] }
  end

  def utm_data
    { utm_source: @custom_headers['utm-source'],
      utm_medium: @custom_headers['utm-medium'],
      utm_term: @custom_headers['utm-term'],
      utm_content: @custom_headers['utm-content'],
      utm_campaign: @custom_headers['utm-campaign'] }
  end

  def permalink_data
    { permalink_slug: @permalink.slug }
      .merge(permalink_node_data).merge(permalink_node_module_data)
      .merge(permalink_data_for('item')).merge(permalink_data_for('medium'))
      .merge(permalink_answer_data).merge(content_rating_data)
      .merge(source_attr)
  end

  def content_rating_data
    { content_rating: @rating }
  end

  def source_attr
    { source_name: @source_name, source_id: @source_id }
  end

  def permalink_answer_data
    { permalink_answer_id: @answer_id,
      permalink_answer_correct: @correct_answer,
      submission_at: @subsmission_at,
      submission_token: @submission_token,
      starts_at: @starts_at }
  end

  def permalink_data_for(entity_class)
    { "permalink_#{entity_class}".to_sym =>
        @permalink.public_send(entity_class).name,
      "permalink_#{entity_class}_id".to_sym =>
        @permalink.public_send("#{entity_class}_id"),
      "permalink_#{entity_class}_type".to_sym =>
        @permalink.public_send(entity_class)
                  .public_send("#{entity_class}_type"),
      "permalink_#{entity_class}_slug".to_sym =>
        @permalink.public_send(entity_class).slug }
  end

  def permalink_node_module_data
    { permalink_node_module: @permalink.node_module.name,
      permalink_node_module_id: @permalink.node_module_id,
      permalink_node_module_slug: @permalink.node_module.slug }
  end

  def permalink_node_data
    { permalink_node: @permalink.nodes.map(&:name),
      permalink_node_slug: @permalink.nodes.map(&:slug),
      permalink_node_type: @permalink.nodes.map(&:node_type),
      permalink_node_id: @permalink.node_ids }
  end

  def user_data
    return empty_user_data if @empty_user

    { user_id: user.id, user_email: user.email,
      user_name: user.name, user_premium: subscriber?,
      user_objective: user.objective, user_objective_id: user.objective_id }
  end

  def subscriber?
    user.accesses.count > 0
  end

  def empty_user_data
    { user_id: '', user_email: '', user_name: '', user_premium: '' }
  end
end
# rubocop:enable Metrics/ModuleLength
