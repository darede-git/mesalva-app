# frozen_string_literal: true

class BaseItemSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :slug,
             :description,
             :free,
             :active,
             :code,
             :created_by,
             :updated_by,
             :item_type,
             :downloadable,
             :tag,
             :streaming_status,
             :listed
  def include_medium?
    user_has_access_to_permalink? && medium_id?
  end

  def medium_id?
    !instance_options[:medium_id].nil?
  end

  def medium
    Permalink::Relation::ChildMediumSerializer
      .new(object.media.find(instance_options[:medium_id])).as_json
  end

  def entity_type
    'item'
  end

  def user_has_access_to_permalink?
    instance_options[:accessible_permalink]
  end

  def status_code
    return 403 unless instance_options[:user_present]

    return 401 unless instance_options[:accessible_permalink]

    200
  end
end
