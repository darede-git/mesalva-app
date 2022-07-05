# frozen_string_literal: true

module DesignSystem
  class DisableStudyPlanButton < ComponentBase
    COMPONENT_NAME = 'DisableStudyPlanButton'
    FIELDS = {
      variant: %i[primary secondary neutral text naked],
      size: %i[sm md],
      label: :string,
      disabled: :boolean,
      study_plan_id: :number,
    }
  end
end
