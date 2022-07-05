# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength

def exercise_search_result
  {
    "_shards" => {
      "total" => 1, "successful" => 1, "failed" => 0
    }, "hits" => {
      "total" => 1, "max_score" => 0.0, "hits" => []
    }, "took" => 1, "timed_out" => false, "aggregations" => {
      "total" => {
        "value" => 1
      }, "stats" => {
        "buckets" => [{
          "key" => "general",
          "to" => 1_535_389_974_108.0,
          "to_as_string" => "2018-08-27T17:12:54.108Z",
          "doc_count" => 1,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0,
            "sum_other_doc_count" => 0,
            "buckets" => [{
              "key" => 72_883,
              "doc_count" => 1,
              "top_event_hits" => {
                "hits" => {
                  "total" => 1,
                  "max_score" => nil,
                  "hits" => [{
                    "_index" => "permalink_events",
                    "_type" => "permalink_event",
                    "_id" => "57765891",
                    "_score" => nil,
                    "_source" => {
                      "id" => 57_765_891,
                      "permalink_slug" => "enem-e-vestibulares/banco-de-provas/enem/provas-do-enem-2017/ciencias-da-natureza-e-suas-tecnologias/91ciencias-da-naturezaenem-2017",
                      "permalink_node" => [
                        "Enem e Vestibulares",
                        "Banco de Provas",
                        "ENEM"
                      ],
                      "permalink_node_module" => "Provas do Enem 2017",
                      "permalink_item" => "Ciências da Natureza e suas Tecnologias",
                      "permalink_medium" => "91Ciências da Natureza-ENEM 2017",
                      "permalink_node_id" => [
                        2,
                        962,
                        968
                      ],
                      "permalink_node_module_id" => 8028,
                      "permalink_item_id" => 61_235,
                      "permalink_medium_id" => 72_883,
                      "permalink_node_type" => %w[education_segment test_repository_group test_repository],
                      "permalink_item_type" => "fixation_exercise",
                      "permalink_medium_type" => "fixation_exercise",
                      "permalink_node_slug" => ['enem-e-vestibulares', 'banco-de-provas', 'enem'],
                      "permalink_node_module_slug" => "provas-do-enem-2017",
                      "permalink_item_slug" => "ciencias-da-natureza-e-suas-tecnologias",
                      "permalink_medium_slug" => "91ciencias-da-naturezaenem-2017",
                      "permalink_answer_id" => 317_451,
                      "permalink_answer_correct" => false,
                      "user_id" => 1_835_332,
                      "user_name" => "Tchuchucao",
                      "user_email" => "tchuchu@cao.com",
                      "user_premium" => false,
                      "user_objective" => "Estudar Engenharia",
                      "user_objective_id" => 7,
                      "event_name" => "exercise_answer",
                      "created_at" => "2018-08-27T16:56:48.809Z",
                      "location" => nil,
                      "client" => "WEB",
                      "device" => "Windows 64",
                      "user_agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/68.0.3440.106 Safari/537.36",
                      "content_rating" => nil,
                      "submission_at" => nil,
                      "submission_token" => nil,
                      "starts_at" => nil
                    },
                    "sort" => [1_535_389_008_809]
                  }]
                }
              }
            }]
          }
        }, {
          "key" => "current-week",
          "from" => 1_534_785_174_108.0,
          "from_as_string" => "2018-08-20T17:12:54.108Z",
          "doc_count" => 1,
          "top_hits" => {
            "doc_count_error_upper_bound" => 0,
            "sum_other_doc_count" => 0,
            "buckets" => [{
              "key" => 72_883,
              "doc_count" => 1,
              "top_event_hits" => {
                "hits" => {
                  "total" => 1,
                  "max_score" => nil,
                  "hits" => [{
                    "_index" => "permalink_events",
                    "_type" => "permalink_event",
                    "_id" => "57765891",
                    "_score" => nil,
                    "_source" => {
                      "id" => 57_765_891,
                      "permalink_slug" => "enem-e-vestibulares/banco-de-provas/enem/provas-do-enem-2017/ciencias-da-natureza-e-suas-tecnologias/91ciencias-da-naturezaenem-2017",
                      "permalink_node" => [
                        "Enem e Vestibulares",
                        "Banco de Provas",
                        "ENEM"
                      ],
                      "permalink_node_module" => "Provas do Enem 2017",
                      "permalink_item" => "Ciências da Natureza e suas Tecnologias",
                      "permalink_medium" => "91Ciências da Natureza-ENEM 2017",
                      "permalink_node_id" => [
                        2,
                        962,
                        968
                      ],
                      "permalink_node_module_id" => 8028,
                      "permalink_item_id" => 61_235,
                      "permalink_medium_id" => 72_883,
                      "permalink_node_type" => %w[education_segment test_repository_group test_repository],
                      "permalink_item_type" => "fixation_exercise",
                      "permalink_medium_type" => "fixation_exercise",
                      "permalink_node_slug" => %w[enem-e-vestibulares banco-de-provas enem],
                      "permalink_node_module_slug" => "provas-do-enem-2017",
                      "permalink_item_slug" => "ciencias-da-natureza-e-suas-tecnologias",
                      "permalink_medium_slug" => "91ciencias-da-naturezaenem-2017",
                      "permalink_answer_id" => 317_451,
                      "permalink_answer_correct" => false,
                      "user_id" => 1_835_332,
                      "user_name" => "Tchuchucao",
                      "user_email" => "tchuchu@cao.com",
                      "user_premium" => false,
                      "user_objective" => "Estudar Engenharia",
                      "user_objective_id" => 7,
                      "event_name" => "exercise_answer",
                      "created_at" => "2018-08-27T16:56:48.809Z",
                      "location" => nil,
                      "client" => "WEB",
                      "device" => "Windows 64",
                      "user_agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/68.0.3440.106 Safari/537.36",
                      "content_rating" => nil,
                      "submission_at" => nil,
                      "submission_token" => nil,
                      "starts_at" => nil
                    },
                    "sort" => [1_535_389_008_809]
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
