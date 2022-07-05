# frozen_string_literal: true

module StudyPlanCurrentWeek
  def self.included(base)
    base.extend(StudyPlanCurrentWeek)
  end

  def current_week_completed_modules
    StudyPlan.connection.select_all(query)
  end

  private

  def query
    <<~SQL
      SELECT
        node_module_id,
        name,
        to_char(spnm.updated_at, 'DD/MM/YYYY') completed_at,
        count(*) OVER() TOTAL
      FROM
        study_plan_node_modules spnm
        INNER JOIN node_modules m2 ON spnm.node_module_id = m2.id
      WHERE
        study_plan_id = #{id}
        AND completed IS TRUE
        AND spnm.created_at != spnm.updated_at
        AND spnm.updated_at BETWEEN to_date(
          current_week('start'),
          'DD/MM/YYYY'
        ) + interval '3 hours'
        AND to_date(
          current_week('finish'),
          'DD/MM/YYYY'
        ) + interval '3 hours';
    SQL
  end
end
