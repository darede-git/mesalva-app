# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module StudyPlanConsumptionHelper
  def medium_type_zero_counters
    {
      "text" => 0, "comprehension_exercise" => 0, "streaming" => 0,
      "fixation_exercise" => 0, "video" => 0, "pdf" => 0,
      "essay" => 0, "public_document" => 0, "soundcloud" => 0, "typeform" => 0,
      "essay_video" => 0, "correction_video" => 0
    }
  end

  def medium_types
    medium_type_zero_counters.keys - ['streaming']
  end

  def generate_study_plan_node_modules
    create_list(:study_plan_node_module, 20,
                study_plan_id: study_plan.id)
  end

  def add_media_to_node_modules
    total_medium_count = medium_type_zero_counters

    subject.week_node_modules.each do |nm|
      items = create_item_list_for_node_module(nm, 1)
      items.each do |item|
        total_medium_count = add_media_to_item(item, total_medium_count)
      end
    end
    total_medium_count
  end

  def add_media_to_item(item, current_counters)
    media = create_medium_for_each_type_for_item(item)
    media.each do |medium|
      current_counters[medium.medium_type] += 1
    end
    current_counters
  end

  def add_consumption_to_node_modules
    total_consumed_medium_count = medium_type_zero_counters
    study_plan.node_modules.each do |node_module|
      node_module.items.each do |item|
        total_consumed_medium_count = \
          add_consumption_to_item_media(item, total_consumed_medium_count)
      end
    end
    PermalinkEvent.import(force: true, refresh: true)
    total_consumed_medium_count
  end

  def add_consumption_to_item_media(item, current_counters)
    item.media.each do |medium|
      event = create_permalink_event_for_medium(medium)
      current_counters[event.permalink_medium_type] += 1 if valid_consumption_events.include?(event.event_name)
    end

    current_counters
  end

  def create_permalink_event_for_medium(medium)
    item = medium.items.first
    node_module = item.node_modules.first
    event_type = medium_type_event_type_map[medium.medium_type]
    FactoryBot
      .create(:"permalink_event_#{event_type}",
              permalink_node_module_id: node_module.id,
              permalink_item_id: item.id,
              permalink_medium_id: medium.id,
              permalink_medium_type: medium.medium_type,
              user_id: user.id)
  end

  def medium_type_event_type_map
    { "text" => 'read',
      "comprehension_exercise" => 'answer',
      "streaming" => 'watch',
      "fixation_exercise" => 'answer',
      "video" => 'watch',
      "pdf" => 'read',
      "essay" => 'read',
      "public_document" => 'read',
      "soundcloud" => 'read',
      "typeform" => 'read',
      "essay_video" => 'watch',
      "correction_video" => 'watch' }
  end

  def permalink_event_types
    %w[watch read rate prep_test answer]
  end

  def valid_consumption_events
    %w[lesson_watch text_read exercise_answer]
  end

  def create_medium_for_each_type_for_item(item)
    medium_types.map do |medium_type|
      create(:"medium_#{medium_type}", items: [item])
    end
  end

  def create_item_list_for_node_module(node_module, qtd)
    create_list(:item, qtd,
                node_modules: [node_module])
  end

  def node_module_consumed_media_count(node_module_id)
    module_consumption_counters = \
      PermalinkEvent.where('permalink_node_module_id = ? and user_id = ? '\
                         "and event_name in ('lesson_watch',"\
                         "'exercise_answer', 'text_read')",
                           node_module_id,
                           user.id)
                    .group('permalink_medium_type')
                    .count(:permalink_medium_id)
    medium_type_zero_counters.merge(module_consumption_counters)
  end
end
# rubocop:enable Metrics/ModuleLength
