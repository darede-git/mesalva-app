# frozen_string_literal: true

module Bff
  module Contents
    module Sections
      class ItemsListElement
        def initialize(item, **attr)
          @item = item
          @active = attr[:active] || false
          @context = attr[:context]
          @children = attr[:children]
        end

        def render
          {
            title: @item.name,
            caption: subtitle,
            link: { href: route },
            icon: icon,
            active: @active,
            icon_color: @active ? "var(--color-info-100)" : "var(--color-background-primary)",
            circle_color: @active ? "var(--color-info-500)" : "var(--color-text-primary)",
            children: @children
          }
        end

        def route
          "/app/#{content_route}/#{@item.token}#{context_sufix}"
        end

        def subtitle
          return video_seconds_duration_label if @item.item_type == 'video'
          if @item.item_type == 'fixation_exercise'
            return "#{@item.media.where(medium_type: 'fixation_exercise').count} exercícios"
          end

          nil
        end

        def icon
          return 'video' if @item.item_type == 'video'
          return 'file-text' if %w[text essay].include?(@item.item_type)

          'edit'
        end

        def content_route
          return 'aula' if @item.full_type.match(/video/)
          return 'texto' if @item.full_type.match(/text/)
          return 'redacao' if @item.full_type.match(/essay/)
          return 'exercicio' if @item.full_type.match(/exercise/)

          'conteudos'
        end

        private

        def context_sufix
          @context ? "?contexto=#{@context}" : ''
        end

        def video_seconds_duration_label
          first_video = @item.media.where(medium_type: 'video').first
          return nil if first_video.nil?

          seconds_duration = first_video.seconds_duration
          return nil if seconds_duration.blank? || seconds_duration.zero?

          minutes_duration = (seconds_duration / 60.0).round
          "#{minutes_duration} minutos"
        end
      end
    end
  end
end
