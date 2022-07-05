# frozen_string_literal: true

FactoryBot.define do
  factory :permalink_event, aliases: [:permalink_event_watch] do
    permalink_slug 'ensino-medio/matematica/algebra-linear'
    permalink_node ['Ensino Médio', 'Matemática']
    permalink_node_module 'Álgebra Linear'
    permalink_item 'Introdução'
    permalink_medium 'Vídeo Introdutório'
    permalink_node_id [1, 2]
    permalink_node_module_id 1
    permalink_item_id 1
    content_rating nil
    permalink_answer_id nil
    permalink_answer_correct nil
    submission_at nil
    submission_token nil
    starts_at nil
    source_id nil
    source_name 'default'

    sequence :permalink_medium_id

    permalink_node_type %w[education_segment subject]
    permalink_item_type 'video'
    permalink_medium_type 'video'
    permalink_node_slug %w[ensino-medio matematica]
    permalink_node_module_slug 'algebra-linear'
    permalink_item_slug 'introducao'
    permalink_medium_slug 'video-introdutorio'
    user_id 1
    event_name 'lesson_watch'
    utm nil

    factory :permalink_event_read do
      permalink_slug 'ensino-medio/' \
        'matematica/algebra-linear/introducao/texto-introdutorio'
      event_name 'text_read'
      permalink_item_type 'text'
      permalink_medium_type 'text'
      permalink_medium 'Texto Introdutório'
    end

    factory :permalink_event_prep_test do
      permalink_slug 'ensino-medio/' \
        'matematica/algebra-linear/introducao/exercicio'
      event_name 'prep_test_answer'
      permalink_answer_id 1
      permalink_answer_correct true
      permalink_item_type 'exercise'
      permalink_medium 'Exercício de Fixação'
      permalink_medium_slug 'exercicio-de-fixacao'
      permalink_medium_type 'fixation_exercise'
      submission_at Time.now.utc
      submission_token 'token'
      starts_at Time.now.utc - 3.hours
    end

    factory :permalink_event_rate do
      event_name 'content_rate'
      content_rating 2
    end

    factory :permalink_event_answer do
      permalink_slug 'ensino-medio/' \
        'matematica/algebra-linear/introducao/exercicio'
      event_name 'exercise_answer'
      permalink_answer_id 1
      permalink_answer_correct true
      permalink_item_type 'exercise'
      permalink_medium 'Exercício de Fixação'
      permalink_medium_slug 'exercicio-de-fixacao'
      permalink_medium_type 'fixation_exercise'
    end

    factory :permalink_event_public_document_read do
      permalink_slug 'engenharia/' \
        'ufrgs/calculo-diferencial-e-integral-i-ufrgs'
      event_name 'public_document_read'
      permalink_item_type 'text'
      permalink_medium_type 'public_document'
      permalink_medium 'Prova 2015'
    end

    factory :permalink_event_soundcloud_read do
      permalink_slug 'engenharia/' \
        'ufrgs/calculo-diferencial-e-integral-i-ufrgs'
      event_name 'soundcloud_listen'
      permalink_item_type 'text'
      permalink_medium_type 'soundcloud'
      permalink_medium 'Ouça no Soundcloud'
    end

    factory :permalink_event_typeform_read do
      permalink_slug 'engenharia/' \
        'ufrgs/calculo-diferencial-e-integral-i-ufrgs'
      event_name 'typeform_answer'
      permalink_item_type 'text'
      permalink_medium_type 'typeform'
      permalink_medium 'Ouça no Soundcloud'
    end

    trait :with_request_headers do
      user_email 'user1@mesalva.com'
      user_name 'Me Salva!'
      user_premium false
      user_objective nil
      user_objective_id nil
      location '41.12,-71.34'
      client 'ANDROID'
      device 'iPhone 6S'
      user_agent 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, /' \
        'like Gecko) Chrome/41.0.2228.0 Safari/537.36'
    end

    trait :with_utm_attributes do
      utm_attributes do
        {
          utm_source: 'enem',
          utm_medium: '320banner',
          utm_term: 'matematica',
          utm_content: '',
          utm_campaign: 'mkt'
        }
      end
    end

    trait :with_utm do
      utm do
        {
          utm_source: 'enem',
          utm_medium: '320banner',
          utm_term: 'matematica',
          utm_content: '',
          utm_campaign: 'mkt'
        }
      end
    end

    trait :with_utm_attributes_blank do
      utm_attributes do
        {
          utm_source: '',
          utm_medium: '',
          utm_term: '',
          utm_content: '',
          utm_campaign: ''
        }
      end
    end
  end
end
