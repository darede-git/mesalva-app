# frozen_string_literal: true

module DesignSystem
  class Image < ComponentBase
    COMPONENT_NAME = 'Image'
    FIELDS = {
      height: :number,
      class_name: :string,
      src: :string,
      # TODO faltam as demais props
    }
  end
end
