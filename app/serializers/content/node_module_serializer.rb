# frozen_string_literal: true

class Content::NodeModuleSerializer < ActiveModel::Serializer
  include SerializationHelper
  include ::ActiveRelativesConcern

  has_many :items, serializer: Content::Relation::NodeModuleItemSerializer
  has_many :media, serializer: Content::Relation::ChildMediumSerializer

  attributes :id,
             :name,
             :slug,
             :code,
             :description,
             :suggested_to,
             :pre_requisite,
             :image,
             :entity_type,
             :instructor,
             :node_module_type,
             :meta_title,
             :meta_description,
             :options,
             :listed

  def entity_type
    'node_module'
  end

  def instructor
    InstructorSerializer.new(object.instructor) if object.instructor.present?
  end
end
