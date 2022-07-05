# frozen_string_literal: true

module MeSalva
  module Event
    module User
      module Content
        class StudyPlan
          def initialize(user)
            @user = user
          end

          def counters
            { 'week' => week_attributes }
          end

          private

          def week_attributes
            { 'modules-count' => modules_count }
          end

          def modules_count
            return 0 if study_plan.nil?

            study_plan.current_week_completed_modules.count
          end

          def study_plan
            @study_plan ||= ::StudyPlan.active
                                       .order('created_at DESC')
                                       .find_by_user_id(@user.id)
          end
        end
      end
    end
  end
end
