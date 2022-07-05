# frozen_string_literal: true

module MeSalva
  module Event
    module Common
      def education_segment_slug_to_name
        @education_segment_slug_to_name ||= education_segments.map do |h|
          { h['slug'] => h['name'] }
        end.reduce({}, :merge)
      end

      def consumption_events
        [
          { match: { event_name: @source::LESSON_WATCH } },
          { match: { event_name: @source::EXERCISE_ANSWER } },
          { match: { event_name: @source::TEXT_READ } },
          { match: { event_name: @source::PUBLIC_DOCUMENT_READ } }
        ]
      end

      def education_segments
        @education_segments ||=
          Node.where(node_type: 'education_segment').as_json
      end

      def education_segment_slugs
        @education_segment_slugs ||= education_segments.map { |h| h['slug'] }
      end

      def should_match
        segments = education_segment_slugs.map do |n|
          { match: { permalink_slug: n } }
        end
        (segments << consumption_events).flatten
      end
    end
  end
end
