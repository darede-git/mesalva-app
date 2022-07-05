# frozen_string_literal: true

module MeSalva
  module Event
    module User
      module Content
        class Essay
          def initialize(user)
            @user = user
          end

          def counters
            { 'total' => total_attributes,
              'week' => week_attributes }
          end

          private

          def total_attributes
            { 'max-grade' => essay_stats['max_grade'].to_i,
              'count' => essay_stats['count'].to_i }
          end

          def week_attributes
            { 'count' => week_count }
          end

          def week_count
            EssaySubmission.current_week_by_user(@user.id).count
          end

          def essay_stats
            @essay_stats ||= ::EssaySubmission.stats_by_user(@user.id).first
          end
        end
      end
    end
  end
end
