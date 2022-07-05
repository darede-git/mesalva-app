# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

def histogram_query(user_id)
  {
    size: 0, query: {
      bool: {
        must: [{ match: { user_id: user_id } },
               { prefix:
                 { 'permalink_slug.raw': 'enem-e-vestibulares/materias/' } },
               { range: {
                 created_at: { gte: Time.now.beginning_of_year }
               } }],
        should: [
          { match: { event_name: 'lesson_watch' } },
          { match: { event_name: 'exercise_answer' } }
        ]
      }
    },
    aggs: {
      activities_per_week: {
        date_histogram: {
          field: 'created_at',
          interval: 'week',
          format: 'w'
        }
      }
    }
  }
end
# rubocop:enable Metrics/MethodLength
