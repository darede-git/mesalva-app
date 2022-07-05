# frozen_string_literal: true

class Permalink::NodeModuleSerializer < ActiveModel::Serializer
  include SerializationHelper
  include ::ActiveRelativesConcern

  has_many :items, serializer: Permalink::Relation::NodeModuleItemSerializer
  has_many :media, serializer: Permalink::Relation::ChildMediumSerializer

  attributes :id,
             :name,
             :slug,
             :code,
             :description,
             :suggested_to,
             :pre_requisite,
             :image,
             :entity_type,
             :medium_count,
             :seconds_duration,
             :instructor,
             :node_module_type,
             :color_hex,
             :listed

  def entity_type
    'node_module'
  end

  def instructor
    InstructorSerializer.new(object.instructor) if object.instructor.present?
  end
end
