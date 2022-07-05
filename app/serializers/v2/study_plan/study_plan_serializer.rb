# frozen_string_literal: true

class V2::StudyPlan::StudyPlanSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :dash

  attributes :id, :shifts, :start_date, :end_date, :available_time
  has_one :user
  has_many :study_plan_node_modules,
           serializer: ::V2::StudyPlan::StudyPlanNodeModuleSerializer
end
