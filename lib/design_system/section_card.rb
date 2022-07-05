# frozen_string_literal: true

module DesignSystem
  class SectionCard < ComponentBase
    COMPONENT_NAME = 'SectionCard'
    FIELDS = {
      title: :string,
      children: :any,
      class_name: :string
    }
  end
end
