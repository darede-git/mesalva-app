# frozen_string_literal: true

module Bff
  module Templates
    module CoursePages
      class CoursePageContent < CoursePageBase
        def initialize(course_slug)
          @course_slug = course_slug
        end

        def render
          {
            "component": "Page",
            "title": "Turma | #{@summary['name']} | Me Salva!",
            "children": [title_section].concat(notifications).concat([main_section]),
            "description": ""
          }
        end

        private

        LABEL_VARIANTS = {
          "default" => 'info',
          "#0C53B7" => 'info',
          '#469A25' => 'success',
          "#B78103" => 'warSning'
        }.freeze

        def notifications
          all_notifications = []
          all_notifications << video_notification unless @summary['sellingBanner']['video'].nil?
          return all_notifications if @summary['notifications'].nil?

          @summary['notifications'].each do |notification|
            all_notifications << {
              "component": "CardNotification",
              "closeable": true,
              "id": "course-class-notification-#{@summary['slug']}-#{Digest::MD5.hexdigest(notification['title'])}",
              "icon": { "name": "info" },
              "title": notification['title'],
              "text": notification['text'],
              "button": {
                "label": notification['cta']['text'],
                "target": notification['cta']['target'],
                "href": notification['cta']['href']
              }
            }
          end
          all_notifications
        end

        def tags_to_labels(tags)
          return nil if tags.nil?

          tags.map do |tag|
            variant = LABEL_VARIANTS[tag['color']] || tag['default']
            { "children": tag['text'], "theme": "ghost", "variant": variant }
          end
        end

        def ensure_full_url(url)
          return url if url.match(/^http/)

          "#{ENV['DEFAULT_URL']}#{url}"
        end

        def content_lesson(item)
          {
            "icon": { "name": "video" },
            "overline": item['hour'],
            "title": item['title'],
            "id": item['href'].split('/').last,
            "link": { "href": ensure_full_url(item['href']) },
            "labels": tags_to_labels(item['tags'])
          }
        end

        def week_days
          beginning_of_week = (Date.new(Date.today.year) + (week_offset + page_number - 1).weeks).beginning_of_week
          days = []
          i = 0
          @first_date = beginning_of_week + i.days
          titles = @page['children'].map { |child| child['title'] }
          while i < 6
            @last_date = beginning_of_week + i.days
            day_number = @last_date.day.to_s.rjust(2, '0')
            is_current = @last_date == Date.today
            day_id = "dia-#{day_number}"
            disabled = !titles.any? do |title|
              title.match?(MeSalva::DateHelper.wday_name(@last_date, true)) && title.match?(day_number)
            end
            @current_day_id = day_id if is_current
            days << {
              "title": day_number,
              "subtitle": MeSalva::DateHelper.wday_name(@last_date, true),
              "active": is_current,
              "disabled": disabled,
              "href": "#dia-#{day_number}"
            }
            i += 1
          end
          days
        end

        def day_id(child)
          return nil unless child['title'].match(%r{.*(\d{2}/\d{2})})

          number = child['title'].gsub(%r{.*(\d{2})/\d{2}}, '\1')
          "dia-#{number}"
        end

        def previous_navigation
          return { disabled: true } if page_number == 1

          {
            disabled: false,
            href: "/app/turmas/#{@course_slug}/#{page_number - 1}"
          }
        end

        def next_navigation
          return { disabled: true } if page_number >= @summary['totalWeeks']

          {
            disabled: false,
            href: "/app/turmas/#{@course_slug}/#{page_number + 1}"
          }
        end

        def group_navigation(list)
          {
            "component": "GroupNavigation",
            "title": "de #{@first_date.day.to_s.rjust(2, '0')} de #{MeSalva::DateHelper.month_name(@first_date)} a #{@last_date.day.to_s.rjust(2, '0')} de #{MeSalva::DateHelper.month_name(@last_date)}",
            "targetId": "programacao-da-semana",
            "previous": previous_navigation,
            "next": next_navigation,
            "list": list
          }
        end

        def dynamic_content_children
          children = []
          children << group_navigation(week_days)
          day_list = []
          @page['children'].map do |child|
            day_list << {
              "component": "Accordion",
              "id": day_id(child),
              "title": child['title'],
              "active": default_open(child),
              "default_open": default_open(child),
              "children": [{
                             "component": "ComponentList",
                             "emptyMessage": "Nenhuma aula ao vivo para esse dia",
                             "list": child['children'].map { |item| content_lesson(item) }
                           }]
            }
          end
          children << {
            "component": "ComponentTodoList",
            "is_editable": true,
            "event_slug": "course_classes/#{@course_slug}/#{page_number}",
            "children": day_list
          }
          children
        end

        def fixed_content_children
          children = []
          fixed_content = []
          @summary['fixedContent']['children'].each do |child|
            fixed_content << {
              "component": "Accordion",
              "id": day_id(child),
              "title": child['title'],
              "active": default_open(child),
              "default_open": default_open(child),
              "children": [{
                             "component": "ComponentList",
                             "emptyMessage": "Nenhuma aula ao vivo para esse dia",
                             "list": child['children'].map { |item| content_lesson(item) }
                           }]
            }
          end
          children << {
            "component": "ComponentTodoList",
            "is_editable": true,
            "event_slug": "course_classes/#{@course_slug}/fixed-content",
            "children": fixed_content
          }
          children
        end

        def dynamic_content_card
          {
            "component": "SectionCard",
            "title": @page['title'],
            "children": dynamic_content_children
          }
        end

        def fixed_content_card
          return nil if @summary['fixedContent'].nil?

          {
            "component": "SectionCard",
            "title": @summary['fixedContent']['title'],
            "children": fixed_content_children
          }
        end

        def default_open(child)
          return false unless @current_day_id

          day_id(child) == @current_day_id
        end

        def default_essay_card
          {
            "component": "CardCta",
            "controller": "getEssayWeekly",
            "schema": {
              "buttons": [
                {
                  "size": "sm",
                  "href": "https://mesalva.com/{{essayWeekly.permalink}}",
                  "children": "Ver o tema"
                }
              ]
            },
            "title": "Redação da Semana",
            "text": "Confira o tema da Redação da Semana e pratique sua escrita cada vez mais!",
            "image": {
              "src": "https://cdn.mesalva.com/uploads/image/MjAyMi0wNi0wNiAxNDowNzowOCArMDAwMDE3ODA5Mw%3D%3D%0A.svg"
            }
          }
        end

        def events_card(premium = false)
          events = @summary['events']
          {
            "component": "SectionCard",
            "constraints": {
              operation: premium ? "contains" : "not-contains",
              key: "courseClassLabels",
              value: @course_slug
            },
            "children": [
              {
                "component": "Grid",
                "children": [
                  {
                    "component": "Heading",
                    "size": "xs",
                    "children": events['title']
                  }
                ].concat(events['content'].map { |event| event_to_button(event, premium) })
              }
            ]
          }
        end

        def sidebar_cards
          cards = []
          cards << default_essay_card unless @summary['cards']['hideEssayCard']
          cards << events_card(false) if @summary['events']
          cards << events_card(true) if @summary['events']
          if @summary['cards']['customCards']
            @summary['cards']['customCards'].each do |card|
              cards << {
                "component": "CardCta",
                "title": card['title'],
                "text": card['text'],
                "image": { "src": card['image'] },
                "buttons": [
                  DesignSystem::Button.render(children: card['cta']['text'],
                                              size: :sm,
                                              href: external_link(card['cta']['href']))
                ]
              }
            end
          end
          cards
        end

        def external_link(href)
          href.match(/^http/) ? href : "https://www.mesalva.com/#{href.gsub(%r{^/}, '')}"
        end

        def event_to_button(event, premium = false)
          permalink = premium ? event['premium']['permalink'] : event['permalink']
          href = external_link(permalink)
          {
            "component": "ItemButton",
            "image": event['image'],
            "title": event['name'],
            "href": href
          }
        end

        def main_section
          return empty_page(@summary['releasePage']) if page_number < 0
          return empty_page(@summary['emptyPage']) if @page.nil?

          {
            "component": "Grid",
            "columns": { "md": [2, 1] },
            "growing": false,
            "children": [
              { component: 'Grid', children: [dynamic_content_card, fixed_content_card] },
              {
                "component": "Grid",
                "columns": { "md": 1 },
                "children": sidebar_cards
              }
            ]
          }
        end

        def empty_page(message)
          {
            "component": "Grid",
            "columns": { "md": [2, 1] },
            "growing": false,
            "children": [
              { component: 'Grid', children: [
                message || default_empty_page
              ] },
              {
                "component": "Grid",
                "columns": { "md": 1 },
                "children": sidebar_cards
              }
            ]
          }
        end

        def default_empty_page
          {
            component: 'SectionCard',
            title: "Página não encontrada",
            text: "Ops, parece que você avançou para uma semana que ainda não foi ao ar!"
          }
        end

        def title_section
          DesignSystem::SectionTitle.render(title: (@summary['name']).to_s,
                                            breadcrumb: [
                                              { label: "Turmas e cursos", href: "/app/turmas" }
                                            ])
        end

        def video_notification
          video = @summary['sellingBanner']['video']
          return nil if video.blank?

          {
            "id": "course-class-presentation-#{@course_slug}",
            "closeable": true,
            "component": "CardYoutubeNotification",
            "videoId": video,
            "closingMessage": "O vídeo de apresentação ficará disponível na área da turma.",
            "closeButton": {
              "label": "Pular vídeo de apresentação"
            }
          }
        end
      end
    end
  end
end
