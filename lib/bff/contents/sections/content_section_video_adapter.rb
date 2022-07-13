# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ContentSectionVideoAdapter < ConsoleTemplateBase
        def initialize(content, **attr)
          @content = content
          @page_component = 'ConsoleTemplate'
          @context = attr[:context]
          @title = @content.name
        end

        def render(entity_type)
          # right_content_route = ItemsListElement.new(@content).content_route
          # return redirect_to_type(right_content_route) unless right_content_route == entity_type
          {
            component: 'ConsoleTemplate',
            title: "#{@content.name} | Me Salva!",
            description: @description,
            image: @image,
            content: {
              title: @content.name,
              children: sections,
            },
            sidebar: {
              list: items_list
            }
          }
        end

        def items_list
          @parent = @content.parents.first
          return @item_list = [] if @parent.nil?

          @parent.active_children.map do |item|
            ItemsListElement.new(item, active: item.token == @content.token, context: @context).render
          end
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
          ]
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
            "event_slug": "contents/#{@context}/#{@content.token}",
            "provider": medium.provider
          }
        end

        def sections
          [
            DesignSystem::Breadcrumb.content_go_back(@context || @content.parents.first.token),
            DesignSystem::Grid.render(children:[video]),
            DesignSystem::Grid.render(columns: [3, 1], children: [
              DesignSystem::SectionTitle.title(@content.name),
              rating_section
            ]),
            DesignSystem::Text.html(@content.description || ''),
            DesignSystem::Divider.render,
            DesignSystem::SectionCard.render(title: "Comentários", text: "exemplo de comentários")
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
      end
    end
  end
end
