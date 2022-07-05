# frozen_string_literal: true

class StudyPlan < ActiveRecord::Base
  include StudyPlanCurrentWeek
  DASHBOARD_SIZE = ENV['STUDY_PLAN_DASHBOARD_DAYS']

  belongs_to :user
  validates_presence_of :user

  scope :active, -> { where(active: true) }

  has_many :study_plan_node_modules, lambda {
    sql = 'completed DESC'
    order(sql)
  }
  has_many :node_modules, through: :study_plan_node_modules do
    def completed
      where('study_plan_node_modules.completed is true')
        .order('study_plan_node_modules.updated_at')
    end

    def not_completed
      where('study_plan_node_modules.completed is false')
        .order('study_plan_node_modules.position')
    end
  end

  def node_modules_count
    node_modules.count
  end

  def completed_node_modules_count
    node_modules.completed.count
  end

  def week_study_plan_node_modules
    study_plan_node_modules.order(:id)
                           .limit(limit)
                           .offset(offset)
  end

  def week_node_modules
    week_study_plan_node_modules
      .includes(:node_module)
      .map(&:node_module)
  end

  def modules_per_week
    return 0 if already_finished?

    week_count = (remaining_modules.count.to_f / remaining_weeks.to_f).ceil
    return remaining_modules.count if week_count == 1

    week_count
  end

  def remaining_weeks
    return 1 if last_week?

    (remaining_days_without_current_week / 7).floor + 1
  end

  private

  def decorate(list)
    list.map do |hash|
      hash.transform_values do |v|
        if v.methods.include? :strftime
          v.strftime('%d/%m/%Y')
        else
          v
        end
      end
    end
  end

  def dashboard_columns
    "study_plan_node_modules.id, name, slug, study_plan_node_modules\
.updated_at AS completed_at, COUNT(*) OVER() total"
  end

  def dashboard_filter
    "study_plan_node_modules.updated_at >= now()::DATE - #{DASHBOARD_SIZE} AND \
study_plan_node_modules.completed IS TRUE"
  end

  def remaining_days
    return 0 if already_finished?

    return (end_date.to_date - Time.now.to_date).to_i if already_started?

    (end_date.to_date - start_date.to_date).to_i
  end

  def remaining_modules
    node_modules.not_completed
  end

  def current_week_completed?
    week_study_plan_node_modules.pluck(:completed).all?
  end

  def already_started?
    Time.now > start_date
  end

  def already_finished?
    Time.now >= end_date
  end

  def remaining_days_without_current_week
    remaining_days - remaining_days_in_current_week
  end

  def remaining_days_in_current_week
    return remaining_days_in_first_week unless already_started?

    (Time.now.end_of_week.to_date - Time.now.to_date).to_i
  end

  def remaining_days_in_first_week
    (start_date.to_date.end_of_week - start_date.to_date).to_i
  end

  def last_week?
    Time.now >= end_date.beginning_of_week
  end
end
