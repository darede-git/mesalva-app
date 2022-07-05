# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionVideoAdapter < ContentSectionAdapterBase
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

        def video
          if @content.free
            return {
              "component": "Video",
              "event_slug": "contents/#{@parent.token}/#{@content.token}",
              "provider": medium.provider,
              "video_id": medium.video_id
            }
          end
          {
            "component": "Video",
            "controller": "getBffApi",
            "endpoint": "user/contents/video/#{medium.token}",
            "event_slug": "contents/#{@parent.token}/#{@content.token}",
            "provider": medium.provider
          }
        end

        def sections
          [
            DesignSystem::Breadcrumb.content_go_back(@context || @content.parents.first.token),
            {
              "component": "Grid",
              "children": [video]
            },
            DesignSystem::Grid.render(columns: [3, 1], children: [
              DesignSystem::SectionTitle.title(@content.name),
              rating_section
            ]),
            DesignSystem::Text.html(@content.description || ''),
            { "component": "Divider" },
            { "component": "SectionCard",
              "title": "Comentários",
              text: "exemplo de comentários" }
          ]
        end

        def rating_section
          { component: 'div',
            class_name: 'flex justify-content-end align-items-center gap-sm',
            children: [
              { component: "Text", children: 'Avalie Esta aula:' },
              { component: "RatingStar",
                "controller": "getBffApi",
                "endpoint": "user/contents/rating/#{medium.token}",
                "max_value": 5
              },
            ] }
        end

        def medium
          @medium ||= @content.active_children.first
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
