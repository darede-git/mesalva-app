# frozen_string_literal: true

module DesignSystem
  class DangerousHtml < ComponentBase
    COMPONENT_NAME = 'DangerousHTML'
    FIELDS = {
      size: DEFAULT_SIZES,
      html: :string,
      children: :any,
    }

    def self.html(html)
      self.render(html: html)
    end
  end
end
