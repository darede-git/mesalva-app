# frozen_string_literal: true

module MeSalva
  module StudyPlan
    module NodeModule
      class Finder
        def self.find_user_accessible_modules_by_subject_ids(user_id,
                                                             subject_ids)
          ::StudyPlanNodeModule.by_user_subjects(user_id, subject_ids)
        end

        def self.previous_study_plan_completed_modules_id_and_position(
          current_study_plan_id,
          user_id
        )
          last_study_plan = \
            ::StudyPlan
            .where(user_id: user_id)
            .where.not(id: current_study_plan_id)
            .order(created_at: :desc)
            .first

          return [] unless last_study_plan

          last_study_plan.node_modules
                         .completed
                         .pluck(:node_module_id, :position)
        end
      end
    end
  end
end
