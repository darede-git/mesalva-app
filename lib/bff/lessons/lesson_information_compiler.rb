# frozen_string_literal: true

module Bff
  module Lessons
    class LessonInformationCompiler

      def initialize(lesson)
        @lesson = lesson
      end

      STATUS_ICONS = { upcoming: { name: "clock",
                                   color: "var(--color-warning-500)" },
                       live: { name: "live-circle",
                                   color: "var(--color-primary-500)" },
                       finished: { name: "checkmark-circle",
                                   color: "var(--color-neutral-500)" } }.freeze

      def mars_icon
        STATUS_ICONS[status.to_sym]
      end

      def status
      return 'upcoming' if upcoming_class?
    
        return 'live' if live_class?
    
        'finished' if finished_class?
      end
  
     

      def upcoming_class?
        @lesson.starts_at.strftime('%H:%M') > Time.now.strftime('%H:%M')
      end
    
      def live_class?
        @lesson.starts_at.strftime('%H:%M') < Time.now.strftime('%H:%M') &&
          @lesson.ends_at.strftime('%H:%M') > Time.now.strftime('%H:%M')
      end
    
      def finished_class?
        @lesson.ends_at.strftime('%H:%M') < Time.now.strftime('%H:%M')
      end

      def images
        @lesson.content_teachers.map { |teacher| teacher['image'] }
      end
    
      def teacher_name_formated
        @lesson.content_teachers.map { |teacher| teacher.name.titleize }
      end
    
      def href
        @lesson.main_permalink.slug
      end

    end
  end
end