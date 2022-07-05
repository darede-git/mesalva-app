# frozen_string_literal: true

class Content::Relation::NodeModuleItemSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :slug,
             :description,
             :free,
             :active,
             :code,
             :item_type,
             :entity_type,
             :downloadable,
             :streaming_status,
             :options

  def entity_type
    'item'
  end
end
