# frozen_string_literal: true

module DesignSystem
  class Button < ComponentBase
    COMPONENT_NAME = 'Button'
    FIELDS = {
      variant: %i[primary secondary neutral text naked],
      size: DEFAULT_SIZES,
      children: :any,
      disabled: :boolean,
      icon_name: :string,
      href: :string
    }
  end
end
