# frozen_string_literal: true

module SisuInstitutesWeightingsQuery
  def self.included(base)
    base.extend(SisuInstitutesWeightingsQuery)
  end

  # rubocop:disable Metrics/MethodLength
  def scores_by_state_ies(state, course, **scores) # TODO remover casos especiais forçados como true e pegar da nova tabela ou passar os dados para a tabela antiga (sisu_institutes)
    # rubocop:disable Layout/LineLength
    query = "WITH scores AS
  ( SELECT #{scores[:cnat]}::FLOAT cnat_score,
           #{scores[:chum]}::FLOAT chum_score,
           #{scores[:ling]}::FLOAT ling_score,
           #{scores[:mat]}::FLOAT mat_score,
           #{scores[:red]}::FLOAT red_score )
SELECT tmp.*,
       CAST(SUM((cnat_avg + chum_avg + ling_avg + mat_avg + red_avg)/(cnat_weight + chum_weight + ling_weight + mat_weight + red_weight)) as DECIMAL(8,2)) average,
       CAST(SUM((cnat_avg + chum_avg + ling_avg + mat_avg + red_avg)/(cnat_weight + chum_weight + ling_weight + mat_weight + red_weight)) - passing_score as DECIMAL(8,2)) approval_prospect,
       CASE WHEN passing_score > SUM((cnat_avg + chum_avg + ling_avg + mat_avg + red_avg)/(cnat_weight + chum_weight + ling_weight + mat_weight + red_weight))
         THEN false
         ELSE true
        END chances
FROM
  ( SELECT DISTINCT initials,
           ies,
           coalesce(college, '') college,
           sisu_institutes.course,
           grade,
           sisu_institutes.shift,
           modality,
           sisu_institutes.semester,
           coalesce(cnat_weight, 1) cnat_weight,
           coalesce(chum_weight, 1) chum_weight,
           coalesce(ling_weight, 1) ling_weight,
           coalesce(mat_weight, 1) mat_weight,
           coalesce(red_weight, 1) red_weight,
           scores.cnat_score cnat_score,
           scores.chum_score,
           scores.ling_score,
           scores.mat_score,
           scores.red_score,
           coalesce(cnat_weight * cnat_score, cnat_score) cnat_avg,
           coalesce(chum_weight * chum_score, chum_score) chum_avg,
           coalesce(ling_weight * ling_score, ling_score) ling_avg,
           coalesce(mat_weight * mat_score, mat_score) mat_avg,
           coalesce(red_weight * red_score, red_score) red_avg,
           (
            CASE passing_score
            WHEN '0'
            THEN 1000
            ELSE CAST(REPLACE(passing_score, ',', '.') as DECIMAL(8,2))
            END
          ) passing_score,
           trans,
           indigena,
           deficiencia,
           publica,
           carente,
           afro
   FROM sisu_institutes
   LEFT JOIN sisu_weightings ON institute = ies
   AND sisu_institutes.course = sisu_weightings.course
   AND sisu_institutes.shift = sisu_weightings.shift
   AND sisu_institutes.year = sisu_weightings.year
   AND sisu_institutes.semester = sisu_weightings.semester
   LEFT JOIN scores ON TRUE
   WHERE sisu_institutes.year = '#{ENV['SISU_YEAR']}'
     AND sisu_institutes.semester = '#{ENV['SISU_SEMESTER']}'
     AND state = '#{state}'
     AND sisu_institutes.course = '#{course}') tmp
GROUP BY initials,
         ies,
         college,
         course,
         grade,
         shift,
         modality,
         passing_score,
         semester,
         cnat_weight,
         chum_weight,
         ling_weight,
         mat_weight,
         red_weight,
         cnat_score,
         chum_score,
         ling_score,
         mat_score,
         red_score,
         cnat_avg,
         chum_avg,
         ling_avg,
         mat_avg,
         red_avg,
         trans,
         indigena,
         deficiencia,
         publica,
         carente,
         afro
ORDER BY chances DESC NULLS LAST, approval_prospect DESC"

    SisuInstitute.connection
                 .select_all(query)
                 .to_hash
    # rubocop:enable Layout/LineLength
  end
  # rubocop:enable Metrics/MethodLength
end
