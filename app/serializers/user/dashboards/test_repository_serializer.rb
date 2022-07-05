# frozen_string_literal: true

class User::Dashboards::TestRepositorySerializer < BaseExerciseAnswersSerializer
  attributes :results

  def results
    { 'total-count' => total_count,
      'exercises' => exercises }
  end

  private

  def total_count
    object.results
          .map { |hits| hits['_source']['permalink_medium_id'] }
          .uniq
          .count
  end

  def item_media
    @item_media ||= Item.find(item_id).media
  end

  def item_id
    object.results.first['_source']['permalink_item_id']
  end

  def exercises
    item_media.map.with_index(1) do |medium, index|
      answer = result_for(medium.id)

      { 'order' => index,
        'medium-name' => medium.name,
        'medium-text' => medium.medium_text,
        'correction' => medium.correction,
        'correct-answer-id' => medium.correct_answer_id,
        'slug' => answer['permalink_medium_slug'],
        'correct' => answer['permalink_answer_correct'],
        'answer-id' => answer['permalink_answer_id'] }
    end
  end

  def result_for(medium_id)
    result = object.results.collect do |hits|
      hits['_source'] if hits['_source']['permalink_medium_id'] == medium_id
    end.compact.last
    result ||= {}
    result
  end

  def permalink_media_ids
    object.results.map { |r| r['_source']['permalink_medium_id'] }
  end
end
