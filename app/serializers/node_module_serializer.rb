# frozen_string_literal: true

class NodeModuleSerializer < ActiveModel::Serializer
  include SerializationHelper

  has_many :media, serializer: EntityMediumSerializer
  has_many :items, serializer: EntityItemSerializer
  has_many :nodes, serializer: EntityNodeSerializer

  attributes :id,
             :name,
             :slug,
             :code,
             :description,
             :suggested_to,
             :pre_requisite,
             :image,
             :created_by,
             :updated_by,
             :active,
             :instructor,
             :relevancy,
             :position,
             :node_module_type,
             :token,
             :listed

  def instructor
    InstructorSerializer.new(object.instructor) if object.instructor.present?
  end
end
