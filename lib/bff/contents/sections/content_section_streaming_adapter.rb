# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionStreamingAdapter < ContentSectionAdapterBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @context = attr[:context]
          @title = @content.name
        end

        def load_content_list
          set_items_list
          @list = @content.active_children.map do |child|
            {
              "icon": { "name": "checkmark-circle", "color": "var(--color-neutral-500)" },
              "title": child.name,
              "permalink": child.main_permalink&.slug,
              "link": { "href": "/app/conteudos/#{child.token}" }
            }
          end
        end

        def medium
          @medium ||= @content.active_children.where(medium_type: 'streaming').first
        end

        def support_materials
          @support_materials ||= @content.active_children.where("medium_type != 'streaming'")
        end

        def support_materials_section
          return nil unless support_materials.count.positive?

          {
            "component": "ButtonList",
            "list": support_materials.map do |material|
              {
                "label": "Material de Apoio",
                "iconName": "download",
                "variant": "secondary",
                "size": "sm",
                "href": material.attachment.url,
                "target": "_blank"
              }
            end
          }
        end

        def sections
          [
            DesignSystem::Breadcrumb.content_go_back(@context || @content.parents.first.token),
            {
              "component": "Grid",
              "children": [
                {
                  "component": "Video",
                  "event_slug": "#{@parent.token}/#{@content.token}",
                  "provider": medium.provider,
                  "video_id": medium.video_id
                }
              ]
            },
            DesignSystem::Grid.render(columns: [3, 1], children: [
              DesignSystem::SectionTitle.title(@content.name),
              { component: 'div', children: [
                { component: "Text", children: 'Avalie Esta aula:' },
                { component: "RatingStar", max_value: 5 },
              ]}
            ]),
            DesignSystem::Text.html(@content.description),
            { "component": "Divider" },
            support_materials_section,
            { "component": "Divider" },
            { "component": "SectionTitle", title: "Chat Ao Vivo" },
            {
              component: "DangerousHTML",
              html: "<iframe style=\"min-height: 400px;\" width=\"100%\" frameborder=\"0\" src=\"//www.youtube.com/live_chat?v=#{medium.video_id}&amp;embed_domain=www.mesalva.com\"></iframe>"
            }
          ]
        end

        def set_items_list
          @parent = @content.parents.first
          return @item_list = [] if @parent.nil?

          @items_list = @parent.active_children.map do |item|
            ItemsListElement.new(item, active: item.token == @content.token, context: @context).render
          end
        end
      end
    end
  end
end
