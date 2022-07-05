# frozen_string_literal: true

module MeSalva
  module Event
    module User
      module Content
        class TestRepository
          PERMALINK = 'enem-e-vestibulares/banco-de-provas'

          def initialize(user, submission_token = nil)
            @user = user
            @submission_token = submission_token
          end

          def counters
            { 'results' => { 'exercise' => exercise_stats } }
          end

          private

          def exercise_stats
            Exercise.new(user_id: @user.id, permalink: PERMALINK).counters
          end
        end
      end
    end
  end
end
