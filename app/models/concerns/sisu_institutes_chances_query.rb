# frozen_string_literal: true

module SisuInstitutesChancesQuery
  include QueryHelper
  def self.included(base)
    base.extend(SisuInstitutesChancesQuery)
  end

  def chances_by_state_ies_modality(state, course, _modality)
    query = snt_sql([chances_by_state_ies_modality_query,
                     { state: state.upcase, year: ENV['SISU_YEAR'],
                       course: course, semester: ENV['SISU_SEMESTER'] }])
    SisuInstitute.connection.select_all(query).to_hash
  end

  def courses_by_state(state)
    query = snt_sql([courses_by_state_query, { state: state.upcase, year: ENV['SISU_YEAR'] }])
    SisuInstitute.connection.select_all(query).to_hash
  end

  private

  # rubocop:disable Metrics/MethodLength
  def chances_by_state_ies_modality_query
    <<~SQL
      SELECT DISTINCT initials,
                ies,
                coalesce(college, '') college,
                sisu_institutes.course,
                grade,
                sisu_institutes.shift,
                modality,
                passing_score,
                sisu_institutes.semester
        FROM sisu_institutes
        LEFT JOIN sisu_weightings ON institute = ies
        AND sisu_institutes.course = sisu_weightings.course
        AND sisu_institutes.shift = sisu_weightings.shift
        AND sisu_institutes.year = sisu_weightings.year
        AND sisu_institutes.semester = sisu_weightings.semester
        WHERE sisu_institutes.year = :year
          AND sisu_institutes.semester = :semester
          AND state = :state
          AND sisu_institutes.course = :course
        GROUP BY initials,
                ies,
                college,
                sisu_institutes.course,
                grade,
                sisu_institutes.shift,
                modality,
                passing_score,
                sisu_institutes.semester
    SQL
  end

  def courses_by_state_query
    <<~SQL
      SELECT quiz_alternatives.description, quiz_alternatives.value, quiz_alternatives.id
      FROM sisu_institutes
      INNER JOIN quiz_alternatives
      ON sisu_institutes.course = quiz_alternatives.description
      WHERE quiz_alternatives.quiz_question_id = 101#{' '}
      AND state = :state
      AND quiz_alternatives.active
      AND year = :year
      GROUP BY quiz_alternatives.description, quiz_alternatives.value, quiz_alternatives.id
      ORDER BY quiz_alternatives.description
    SQL
  end
  # rubocop:enable Metrics/MethodLength
end
