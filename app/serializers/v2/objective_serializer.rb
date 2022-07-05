# frozen_string_literal: true

class V2::ObjectiveSerializer < V2::ApplicationSerializer
  attributes :name, :education_segment_slug, :crm_name
end
