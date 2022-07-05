# frozen_string_literal: true

module DesignSystem
  class Title < ComponentBase
    COMPONENT_NAME = 'Title'
    FIELDS = {
      size: DEFAULT_SIZES,
      children: :any,
      level: :number,
      variant: %i[subtitle],# TODO faltam as outras variantes
      # TODO faltam as demais props
    }
  end
end
