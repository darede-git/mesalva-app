# frozen_string_literal: true

class User::NodeModuleSerializer < ActiveModel::Serializer
  attributes :id, :name, :permalink

  def permalink
    object.permalinks.where('item_id is null and medium_id is null').first.slug
  end
end
