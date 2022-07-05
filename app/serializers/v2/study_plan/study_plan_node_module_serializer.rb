# frozen_string_literal: true

class V2::StudyPlan::StudyPlanNodeModuleSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attribute :node_module do |object|
    object.node_module.name
  end

  attribute :subject, &:parent_subject_info

  attribute :permalink, &:node_module_permalink_slug

  attributes :position, :completed, :already_known
end
