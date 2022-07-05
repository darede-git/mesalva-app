# frozen_string_literal: true

def histogram_search_result
  { "took" => 63,
    "timed_out" => false,
    "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
    "hits" => { "total" => 79, "max_score" => 0.0, "hits" => [] },
    "aggregations" =>
  { "activities_per_week" =>
    { "buckets" =>
      [{ "key_as_string" => "10", "key" => 1_520_208_000_000, "doc_count" => 8 },
       { "key_as_string" => "11", "key" => 1_520_812_800_000, "doc_count" => 0 }] } } }
end

def histogram_empty_search_result
  { "took" => 65,
    "timed_out" => false,
    "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
    "hits" => { "total" => 0, "max_score" => 0.0, "hits" => [] },
    "aggregations" => { "activities_per_week" => { "buckets" => [] } } }
end
