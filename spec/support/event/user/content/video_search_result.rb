# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength

def video_search_result
  {
    "_shards" => {
      "total" => 1, "successful" => 1, "failed" => 0
    }, "hits" => {
      "total" => 1, "max_score" => 0.0, "hits" => []
    }, "took" => 2, "timed_out" => false, "aggregations" => {
      "total" => {
        "value" => 1
      }, "stats" => {
        "buckets" => [{
          "key" => "general",
          "to" => 1_535_380_064_382.0,
          "to_as_string" => "2018-08-27T14:27:44.382Z",
          "doc_count" => 1,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0,
            "sum_other_doc_count" => 0,
            "buckets" => [{
              "key" => 48_689,
              "doc_count" => 1,
              "top_event_hits" => {
                "hits" => {
                  "total" => 1, "max_score" => nil, "hits" => [{
                    "_index" => "permalink_events",
                    "_type" => "permalink_event",
                    "_id" => "57765889",
                    "_score" => nil,
                    "_source" => {
                      "id" => 57_765_889,
                      "permalink_slug" => "engenharia/cursos/eletronica-analogica-digital/introducao-sistemas-digitais/fluxograma-asm/isd01-fluxograma-asm",
                      "permalink_node" => %w[Engenharia Cursos Eletrônica Analógica e Digital],
                      "permalink_node_module" => "ISD - Introdução a Sistemas Digitais",
                      "permalink_item" => "ISD01 - Fluxograma ASM",
                      "permalink_medium" => "ISD01 - Fluxograma ASM",
                      "permalink_node_id" => [6, 1319, 1321],
                      "permalink_node_module_id" => 8_135,
                      "permalink_item_id" => 63_017,
                      "permalink_medium_id" => 48_689,
                      "permalink_node_type" => %w[education_segment library subject],
                      "permalink_item_type" => "video",
                      "permalink_medium_type" => "video",
                      "permalink_node_slug" => %w[engenharia cursos eletronica-analogica-digital],
                      "permalink_node_module_slug" => "introducao-sistemas-digitais",
                      "permalink_item_slug" => "fluxograma-asm",
                      "permalink_medium_slug" => "isd01-fluxograma-asm",
                      "permalink_answer_id" => nil,
                      "permalink_answer_correct" => nil,
                      "user_id" => 1_835_332,
                      "user_name" => "Tchuchucao",
                      "user_email" => "tchuchu@cao.com",
                      "user_premium" => false,
                      "user_objective" => "Estudar Engenharia",
                      "user_objective_id" => 7,
                      "event_name" => "lesson_watch",
                      "created_at" => "2018-08-27T14:14:25.113Z",
                      "location" => nil,
                      "client" => "WEB",
                      "device" => "Windows 64",
                      "user_agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",
                      "content_rating" => nil,
                      "submission_at" => nil,
                      "submission_token" => nil,
                      "starts_at" => nil
                    },
                    "sort" => [1_535_379_265_113]
                  }]
                }
              }
            }]
          }
        }, {
          "key" => "current-week",
          "from" => 1_534_775_264_381.0,
          "from_as_string" => "2018-08-20T14:27:44.381Z",
          "doc_count" => 1,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0, "sum_other_doc_count" => 0, "buckets" => [{
              "key" => 48_689,
              "doc_count" => 1,
              "top_event_hits" => {
                "hits" => {
                  "total" => 1, "max_score" => nil, "hits" => [{
                    "_index" => "permalink_events",
                    "_type" => "permalink_event",
                    "_id" => "57765889",
                    "_score" => nil,
                    "_source" => {
                      "id" => 57_765_889,
                      "permalink_slug" => "engenharia/cursos/eletronica-analogica-digital/introducao-sistemas-digitais/fluxograma-asm/isd01-fluxograma-asm",
                      "permalink_node" => %w[Engenharia Cursos Eletrônica Analógica e Digital],
                      "permalink_node_module" => "ISD - Introdução a Sistemas Digitais",
                      "permalink_item" => "ISD01 - Fluxograma ASM",
                      "permalink_medium" => "ISD01 - Fluxograma ASM",
                      "permalink_node_id" => [6, 1319, 1321],
                      "permalink_node_module_id" => 8_135,
                      "permalink_item_id" => 63_017,
                      "permalink_medium_id" => 48_689,
                      "permalink_node_type" => %w[education_segment library subject],
                      "permalink_item_type" => "video",
                      "permalink_medium_type" => "video",
                      "permalink_node_slug" => %w[engenharia cursos eletronica-analogica-digital],
                      "permalink_node_module_slug" => "introducao-sistemas-digitais",
                      "permalink_item_slug" => "fluxograma-asm",
                      "permalink_medium_slug" => "isd01-fluxograma-asm",
                      "permalink_answer_id" => nil,
                      "permalink_answer_correct" => nil,
                      "user_id" => 1_835_332,
                      "user_name" => "Tchuchucao",
                      "user_email" => "tchuchu@cao.com",
                      "user_premium" => false,
                      "user_objective" => "Estudar Engenharia",
                      "user_objective_id" => 7,
                      "event_name" => "lesson_watch",
                      "created_at" => "2018-08-27T14:14:25.113Z",
                      "location" => nil,
                      "client" => "WEB",
                      "device" => "Windows 64",
                      "user_agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36",
                      "content_rating" => nil,
                      "submission_at" => nil,
                      "submission_token" => nil,
                      "starts_at" => nil
                    },
                    "sort" => [1_535_379_265_113]
                  }]
                }
              }
            }]
          }
        }]
      }
    }
  }
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Layout/LineLength
