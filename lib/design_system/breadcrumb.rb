# frozen_string_literal: true

module DesignSystem
  class Breadcrumb < ComponentBase
    COMPONENT_NAME = 'SectionTitle'
    FIELDS = {
      title: :string,
      children: :any,
      breadcrumb: :array
    }

    def self.content_go_back(token)
      return nil if token.blank?

      self.render(breadcrumb: [
        {
          "label": "Voltar",
          "href": "/app/conteudos/#{token}"
        }
      ])
    end
  end
end
