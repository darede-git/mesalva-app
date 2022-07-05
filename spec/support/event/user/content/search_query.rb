# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

def search_query(user_id, event_name, permalink)
  {
    size: 0, query: {
      bool: {
        must: [{ match: { user_id: user_id } },
               { prefix: {
                 'permalink_slug.raw': permalink
               } },
               { match: { event_name: event_name } }]
      }
    },
    aggs: {
      total: {
        cardinality: { field: 'permalink_medium_id' }
      },
      stats: {
        date_range: {
          field: 'created_at',
          ranges: [
            { to: Time.now, key: 'general' },
            { from: Time.now.beginning_of_week, key: 'current-week' }
          ]
        },
        aggs: {
          top_hits: {
            terms: { field: 'permalink_medium_id', size: 10_000 },
            aggs: {
              top_event_hits: {
                top_hits: {
                  size: 1,
                  sort: [
                    { created_at: { order: 'desc' } }
                  ]
                }
              }
            }
          }
        }
      }
    }
  }
end
# rubocop:enable Metrics/MethodLength
