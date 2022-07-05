# frozen_string_literal: true

require 'forwardable'

module MeSalva
  module StudyPlan
    class Structure
      extend Forwardable

      def_delegators :@answers, :valid?, :errors, :available_time, :start_date,
                     :shifts, :end_date, :subject_ids, :keep_completed_modules?

      def initialize(attrs)
        @study_plan_id = attrs[:study_plan_id]
        @user_id = attrs[:user_id]
        @answers = parse_answers_from(attrs)
      end

      def build
        return false unless valid?

        user.disable_last_study_plan
        user.reenable_last_study_plan unless study_plan_transaction
      end

      def maintenance
        study_plan_update(offset: offset,
                          limit: study_plan.modules_per_week)
      end

      private

      def study_plan_update(attrs)
        study_plan.update!(attrs)
      end

      def study_plan_transaction
        ActiveRecord::Base.transaction do
          prepend_modules if keep_completed_modules?
          add_available_modules_to_study_plan
          study_plan_update(transaction_attrs)
        end
      end

      def transaction_attrs
        { offset: offset, limit: study_plan.modules_per_week,
          shifts: shifts, estimated_weeks: study_plan.remaining_weeks,
          available_time: available_time, start_date: start_date,
          end_date: end_date, subject_ids: subject_ids,
          keep_completed_modules: keep_completed_modules? }
      end

      def offset
        study_plan.node_modules.completed.count
      end

      def user
        @user ||= ::User.find(@user_id)
      end

      def prepend_modules
        ids = previous_study_plan_node_module_ids
        ids.each do |node_module|
          add_node_module_to_study_plan(node_module_id: node_module[0],
                                        position: node_module[1],
                                        completed: true)
        end
      end

      def previous_study_plan_node_module_ids
        MeSalva::StudyPlan::NodeModule::Finder
          .previous_study_plan_completed_modules_id_and_position(study_plan.id,
                                                                 @user.id)
      end

      def add_available_modules_to_study_plan
        sorted_node_module_ids.each do |node_module|
          add_node_module_to_study_plan(node_module_id: node_module[0],
                                        position: node_module[1])
        end
      end

      def add_node_module_to_study_plan(attrs)
        attrs[:study_plan] = study_plan
        ::StudyPlanNodeModule.create!(attrs)
      end

      def sorted_node_module_ids
        collected_node_modules = MeSalva::StudyPlan::NodeModule::Collector.new(
          available_node_modules: available_node_modules,
          available_time: available_time
        ).collect_for_available_time
        return [] if collected_node_modules.nil?

        ids = collected_node_modules.map { |m| m['id'].to_i }
        ::NodeModule.where(id: ids).order(:position).pluck(:id, :position)
      end

      def ignored_node_module_ids
        return [] unless keep_completed_modules?

        MeSalva::StudyPlan::Current::NodeModules.completed_ids(@user.id)
      end

      def study_plan
        @study_plan   = ::StudyPlan.find(@study_plan_id) if @study_plan_id
        @study_plan ||= ::StudyPlan
                        .create!(user: @user,
                                 start_date: start_date,
                                 end_date: end_date)
      end

      def available_node_modules
        NodeModule::Group.new(available_modules: found_node_modules,
                              ids_to_skip: ignored_node_module_ids)
                         .by_subject_id_and_relevancy
      end

      def found_node_modules
        @found_node_modules ||= MeSalva::StudyPlan::NodeModule::Finder
                                .find_user_accessible_modules_by_subject_ids(
                                  @user.id,
                                  subject_ids
                                )
      end

      def parse_answers_from(attrs)
        Answers.new(attrs)
      end
    end
  end
end
