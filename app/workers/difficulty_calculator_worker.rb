# frozen_string_literal: true

class DifficultyCalculatorWorker
  include Sidekiq::Worker

  def perform
    result = ActiveRecord::Base.connection.execute(query)
    result.each do |row|
      difficulty = difficulty_rating(row['sum'] / row['answer_attempts'].to_f)
      medium = Medium.find(row['medium_id'])
      medium['difficulty'] = difficulty
      medium.save
    end
  end

  private

  def difficulty_rating(correct_percentage)
    if correct_percentage < 0.36
      5
    elsif correct_percentage < 0.53
      4
    elsif correct_percentage < 0.70
      3
    elsif correct_percentage < 0.87
      2
    else
      1
    end
  end

  def query
    <<~SQL
      WITH
      fixation_exercises AS (SELECT id AS event_id,
        CASE permalink_events.permalink_answer_correct
          WHEN 't' THEN 1 ELSE 0 END AS answer_correct,
            permalink_medium_id AS medium_id
        FROM permalink_events
        WHERE permalink_medium_type = 'fixation_exercise'
        ORDER BY permalink_events.id DESC
        LIMIT 1000000),

      unfiltered_table AS (SELECT medium_id,
        SUM(answer_correct),
        COUNT(event_id) AS answer_attempts
        FROM fixation_exercises
        GROUP BY medium_id)

      SELECT * FROM unfiltered_table
      WHERE answer_attempts > #{ENV['MINIMUM_ANSWERS_DIFFICULTY_CALCULATOR']};
    SQL
  end
end
