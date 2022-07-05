# frozen_string_literal: true

class PrepTestAverageCounterWorker
  include Sidekiq::Worker

  def perform(prep_test_id)
    @prep_test = PrepTest.find(prep_test_id)
    return if @prep_test.nil? || @prep_test.prep_test_scores.empty?

    set_test_scores
    update_scores
    count_average_correct
  end

  private

  def set_test_scores
    @cnat = specific_test_scores("natureza")
    @chum = specific_test_scores("humanas")
    @ling_ing = specific_test_scores("linguagens")
    @ling_esp = specific_test_scores("linguagens")
    @mat = specific_test_scores("matematica")
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def update_scores
    cnat_scores = @cnat.pluck(:score)
    chum_scores = @chum.pluck(:score)
    ling_ing_scores = @ling_ing.pluck(:score)
    ling_esp_scores = @ling_esp.pluck(:score)
    mat_scores = @mat.pluck(:score)

    @prep_test.update(
      cnat_min_score: cnat_scores.min,
      cnat_average_score: count_average_score(cnat_scores),
      cnat_max_score: cnat_scores.max,
      chum_min_score: chum_scores.min,
      chum_average_score: count_average_score(chum_scores),
      chum_max_score: chum_scores.max,
      ling_ing_min_score: ling_ing_scores.min,
      ling_ing_average_score: count_average_score(ling_ing_scores),
      ling_ing_max_score: ling_ing_scores.max,
      ling_esp_min_score: ling_esp_scores.min,
      ling_esp_average_score: count_average_score(ling_esp_scores),
      ling_esp_max_score: ling_esp_scores.max,
      mat_min_score: mat_scores.min,
      mat_average_score: count_average_score(mat_scores),
      mat_max_score: mat_scores.max
    )
  end
  # rubocop:enable Metrics/MethodLength

  def count_average_correct
    cnat_tokens = @cnat.pluck(:submission_token)
    chum_tokens = @chum.pluck(:submission_token)
    ling_ing_tokens = @ling_ing.pluck(:submission_token)
    ling_esp_tokens = @ling_esp.pluck(:submission_token)
    mat_tokens = @mat.pluck(:submission_token)

    @prep_test.update(
      cnat_average_correct: count_correct_by_submission(cnat_tokens),
      chum_average_correct: count_correct_by_submission(chum_tokens),
      ling_ing_average_correct: count_correct_by_submission(ling_ing_tokens),
      ling_esp_average_correct: count_correct_by_submission(ling_esp_tokens),
      mat_average_correct: count_correct_by_submission(mat_tokens)
    )
  end
  # rubocop:enable Metrics/AbcSize

  def count_average_score(test_scores)
    test_scores.inject { |sum, el| sum + el }.to_f / test_scores.size
  end

  def specific_test_scores(test_name)
    @prep_test.prep_test_scores.where("permalink_slug like '%#{test_name}%'")
  end

  def count_correct_by_submission(submission_tokens)
    return if submission_tokens.empty?

    ActiveRecord::Base.connection.execute(
      <<~SQL
        with correct_answers as (
          select submission_token, (count(permalink_answer_correct::int)) as correct_answers
          from permalink_events pe
          where id > 99000000
          and event_name = 'prep_test_answer'
          and permalink_answer_correct  = true
          and submission_token =  any(array#{submission_tokens.to_s.tr('"', "'")})
          group by submission_token
          )
          select(avg(correct_answers.correct_answers))
          from correct_answers
      SQL
    ).first['avg']
  end
end
