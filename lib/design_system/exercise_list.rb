# frozen_string_literal: true

module DesignSystem
  class ExerciseList < ComponentBase
    COMPONENT_NAME = 'ExerciseList'
    FIELDS = {
      event_slug: :string,
      list: :any
    }
  end
end
