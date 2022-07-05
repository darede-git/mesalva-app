# frozen_string_literal: true

module Bff
  module Templates
    module CoursePages
      class CoursePageEvents < CoursePageBase
        def user_events(user)
          @user = user
          @events = {}
          @checked_events = []
          @content_slugs = []
          if @page_number == 'fixed-content'
            fixed_content_events
          else
            dynamic_content_events
          end
          LessonEvent.where(user: @user, node_module_slug: @content_slugs, item_slug: "course-class_#{@course_slug}").pluck(:node_module_slug)
        end

        def save_event(user, content_slug)
          LessonEvent.find_or_create(user: user, node_module_slug: content_slug, item_slug: "course-class_#{@course_slug}")
        end

        def destroy_event(user, content_slug)
          LessonEvent.where(user: user, node_module_slug: content_slug, item_slug: "course-class_#{@course_slug}").delete_all
        end

        private

        def dynamic_content_events
          @page['children'].each do |child|
            child['children'].each do |content|
              key = content['href'].split('/').last
              @content_slugs << key
              @events[key] = rand(2) > 0

              @checked_events << key if @events[key]
            end
          end
        end

        def fixed_content_events
          @summary['fixedContent']['children'].each do |child|
            child['children'].each do |content|
              key = content['href'].split('/').last
              @content_slugs << key
              @events[key] = rand(2) > 0

              @checked_events << key if @events[key]
            end
          end
        end
      end
    end
  end
end
