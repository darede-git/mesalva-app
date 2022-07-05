# frozen_string_literal: true

class Permalink::Relation::NodeNodeModuleSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :id,
             :name,
             :slug,
             :code,
             :description,
             :suggested_to,
             :pre_requisite,
             :image,
             :medium_count,
             :seconds_duration,
             :instructor,
             :node_module_type,
             :color_hex

  def instructor
    InstructorSerializer.new(object.instructor) if object.instructor.present?
  end
end
