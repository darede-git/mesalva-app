# frozen_string_literal: true

module MeSalva
  module Event
    module Permalink
      class PrepTestAnswers
        def initialize(attrs)
          @user_id = attrs[:user_id]
          @submission_token = attrs[:submission_token]
          @full = attrs[:full] || false
        end

        def results
          unless @full
            return ExerciseEvent
              .select(:id,:answer_id, :correct, sql_select_from_hash({
                                             "exercise_events.created_at": "submission_at",
                                             "exercise_events.medium_slug": "slug"
                                           }))
              .select("NULL AS correction", "NULL AS answer_correct")
              .where(submission_token: @submission_token)
          end
          ExerciseEvent
            .select(sql_select_from_hash({
                                           "exercise_events.answer_id": "answer_id",
                                           "exercise_events.created_at": "submission_at",
                                           "exercise_events.correct": "correct",
                                           "media.slug": "slug",
                                           "media.correction": "correction",
                                           "answers.id": "answer_correct"
                                         }))
            .joins('INNER JOIN media ON media.slug = exercise_events.medium_slug')
            .joins('INNER JOIN answers ON answers.medium_id = media.id AND answers.correct = TRUE')
            .where(submission_token: @submission_token)
        end

        def sql_select_from_hash(hash)
          hash.map { |key,value| "#{key} as #{value}"}.join(', ')
        end

        def score
          prep_test_score.try(:score)
        end

        private

        def prep_test_score
          PrepTestScore.find_by_submission_token(@submission_token)
        end
      end
    end
  end
end
