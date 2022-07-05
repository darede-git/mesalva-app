# frozen_string_literal: true

module DesignSystem
  class Grid < ComponentBase
    COMPONENT_NAME = 'Grid'
    FIELDS = {
      columns: :any,
      children: :any,
      class_name: :string,
    }
  end
end
