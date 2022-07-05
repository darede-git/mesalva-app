# frozen_string_literal: true

class Permalink::Relation::NodeModuleItemSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :slug,
             :description,
             :free,
             :active,
             :code,
             :item_type,
             :entity_type,
             :status_code,
             :medium_count,
             :seconds_duration,
             :downloadable

  def entity_type
    'item'
  end

  def status_code
    return 200 if instance_options[:accessible_permalink]

    401
  end
end
