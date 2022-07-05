# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

def empty_search_result
  {
    "total" => {
      "value" => 0
    },
    "stats" => {
      "buckets" => [
        {
          "key" => "general",
          "to" => 1_535_814_000_000.0,
          "to_as_string" => "2018-09-01T15:00:00.000Z",
          "doc_count" => 0,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0,
            "sum_other_doc_count" => 0,
            "buckets" => []
          }
        },
        {
          "key" => "current-week",
          "from" => 1_535_209_200_000.0,
          "from_as_string" => "2018-08-25T15:00:00.000Z",
          "doc_count" => 0,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0,
            "sum_other_doc_count" => 0,
            "buckets" => []
          }
        }
      ]
    }
  }
end
# rubocop:enable Metrics/MethodLength
