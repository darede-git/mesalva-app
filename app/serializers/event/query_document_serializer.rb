# frozen_string_literal: true

class Event::QueryDocumentSerializer < ActiveModel::Serializer
  attributes :results

  def results
    permalink_response
  end

  private

  def permalink_response
    return nested_group_by_entity if expanded? && group_by?
    return last_consumed_media if expanded?
    return group_by_entity_medium_count if group_by?

    []
  end

  def nested_group_by_entity
    group_argument = @instance_options[:group_by]

    object.map do |c|
      {
        "#{group_argument}": c['_id']["permalink_#{group_argument}"],
        "media": last_consumed_media_fields(c['media'])
      }
    end
  end

  def last_consumed_media
    object.map do |m|
      last_consumed_media_fields(m['media'])
    end.flatten
  end

  def last_consumed_media_fields(media)
    media.map do |medium|
      {
        medium: medium['medium'],
        'timestamp': medium['created_at'],
        'correct-answer': medium['permalink_answer_correct'],
        'answer-id': medium['permalink_answer_id']
      }
    end
  end

  def group_by_entity_medium_count
    object.map do |c|
      row = {}
      row[@instance_options[:group_by]] = c['_id']
      row['medium-count'] = {}
      row
    end
  end

  def expanded?
    return !@instance_options[:expanded].empty? unless @instance_options[:expanded].nil?

    false
  end

  def group_by?
    return !@instance_options[:group_by].empty? unless @instance_options[:group_by].nil?

    false
  end
end
