# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionAdapterBase
        attr_reader :list, :title, :items_list
        attr_accessor :description, :image

        def page_component
          @page_component || 'Page'
        end

        def load_content_list
          @list = []
        end

        def sections
          [
            { "component": "SectionTitle", "title": @content.name,
              "breadcrumb": [
                {
                  "label": "Voltar",
                  "href": "/app/conteudos/#{@content.parents.first.parents.first.token}"
                }
              ] },
            {
              "component": "Grid",
              "growing": false,
              "columns": {
                "md": "2fr 1fr"
              },
              children: [
                {
                  "component": "SectionCard",
                  "title": @title,
                  "children": [
                    { "component": "ComponentList",
                      enable_filter: true,
                      "filterLabel": @filter_label || "Filtrar conteúdo",
                      "list": @list }
                  ]
                },
                { "component": "SectionCard",
                  "title": "Sobre este conteúdo",
                  children: [
                    component: "Text",
                    html: @content.description
                  ]
                }
              ]
            }
          ]
        end

        def render(entity_type)
          right_content_route = ItemsListElement.new(@content).content_route
          return redirect_to_type(right_content_route) unless right_content_route == entity_type
          load_content_list
          {
            component: page_component,
            title: "#{@content.name} | Me Salva!",
            description: @description,
            image: @image,
            children: sections,
            items_list: items_list
          }
        end

        def redirect_to_type(entity_type)
          redirect_to("/app/#{entity_type}/#{@content.token}")
        end

        def redirect_to(route, component = 'Page')
          {
            component: component,
            children: [
              { component: "Redirect", to: route } ]
          }
        end
      end
    end
  end
end
