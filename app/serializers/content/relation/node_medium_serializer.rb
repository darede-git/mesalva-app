# frozen_string_literal: true

class Content::Relation::NodeMediumSerializer < ActiveModel::Serializer
  attributes :name, :attachment, :slug

  attribute :medium_type, key: 'medium-type'

  def attachment
    object.attachment.serializable_hash
  end
end
