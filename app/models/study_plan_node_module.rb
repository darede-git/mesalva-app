# frozen_string_literal: true

class StudyPlanNodeModule < ActiveRecord::Base
  include StudyPlanUserAccessibleNodeModulesQuery

  before_validation :set_completed_if_needed

  belongs_to :study_plan
  belongs_to :node_module
  validates :study_plan, :node_module, presence: true

  validates_inclusion_of :weekday, in: %w[sunday monday tuesday wednesday
                                          thursday friday saturday],
                                   if: :weekday_present?

  validates_inclusion_of :shift, in: %w[morning mid evening],
                                 if: :shift_present?
  scope :by_study_plan, lambda { |id, offset, limit|
    sql = <<~SQL
      SELECT * FROM (
        SELECT * from study_plan_node_modules
        WHERE study_plan_id = #{id}
            AND completed = true
        ORDER BY updated_at, position, node_module_id
      ) AS completed
      UNION ALL
      SELECT * FROM (
        SELECT * FROM study_plan_node_modules
        WHERE study_plan_id = #{id}
            AND completed = false
        ORDER BY position
      ) AS pending
      OFFSET #{offset}
      LIMIT #{limit}
    SQL
    find_by_sql(sql)
  }

  def parent_subject_info
    return if node_module_permalink.nil?

    node = node_module_permalink.nodes.where(node_type: 'area_subject').first
    { 'name' => node.name, 'color-hex' => node.color_hex }
  end

  def node_module_permalink_slug
    node_module_permalink.try(:slug)
  end

  def node_module_permalink
    @node_module_permalink ||= \
      node_module
      .permalinks
      .where(
        "slug like ?",
        "%/#{ENV['STUDY_PLAN_TOP_NODE_SLUG']}/%"
      )
      .where(item_id: nil, medium_id: nil)
      .first
  end

  private

  def set_completed_if_needed
    return unless completed.nil?

    self.completed = false
  end

  def shift_present?
    shift.present?
  end

  def weekday_present?
    weekday.present?
  end

  def last_position
    module_count + 1
  end

  def module_count
    StudyPlanNodeModule.where('study_plan_id = ?', study_plan.id).count
  end
end
