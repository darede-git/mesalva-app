# frozen_string_literal: true

module DesignSystem
  class SectionTitle < ComponentBase
    COMPONENT_NAME = 'SectionTitle'
    FIELDS = {
      title: :string,
      children: :any,
      breadcrumb: :array
    }

    def self.title(title)
      self.render(title: title)
    end
  end
end
