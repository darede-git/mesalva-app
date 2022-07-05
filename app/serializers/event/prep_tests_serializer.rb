# frozen_string_literal: true

class Event::PrepTestsSerializer < ActiveModel::Serializer
  attributes :results

  def results
    return [] if object.results.nil?

    { 'prep-tests' => prep_tests }
  end

  private

  def prep_tests
    object.results.map do |prep_test|
      prep_attr(prep_test)
    end
  end

  def prep_attr(prep_test)
    {
      'item-slug' => prep_test[:item_slug],
      'item-name' => prep_test[:item_name],
      'submission-token' => prep_test[:submission_token],
      'submission-at' => prep_test[:submission_at]
    }
  end
end
