# frozen_string_literal: true

class Event::PrepTestAnswersSerializer < ActiveModel::Serializer
  attributes :results

  def results
    {
      'created-at' => created_at,
      'answers' => answers,
      'score' => score,
      'duration-in-seconds' => duration_in_seconds
    }
  end

  private

  def answers
    object.results
  end

  def created_at
    object.results.first['submission_at']
  end

  def score
    object.score
  end

  def starts_at
    object.results.first['starts_at']
  end

  def duration_in_seconds
    return 0 if starts_at.nil?

    (created_at - starts_at).to_i
  end
end
