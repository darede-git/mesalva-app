# frozen_string_literal: true

class BaseNodeSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :id,
             :name,
             :slug,
             :description,
             :image,
             :video,
             :color_hex,
             :created_by,
             :updated_by,
             :node_type,
             :suggested_to,
             :pre_requisite,
             :listed

  def children
    children = object.children.active.listed.without_study_tools

    return [] if children.empty?

    ActiveModel::Serializer::CollectionSerializer
      .new(children,
           serializer: relatives_serializer,
           key_transform: :dasherize)
  end

  def parent
    relatives_serializer.new(object.parent) unless object.parent.nil?
  end

  def entity_type
    'node'
  end

  private

  def relatives_serializer
    raise NotImplementedError
  end
end
