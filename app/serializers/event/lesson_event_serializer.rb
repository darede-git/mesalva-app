# frozen_string_literal: true

class Event::LessonEventSerializer < ActiveModel::Serializer
  attributes :results

  def results
    { "item": :item_slug, "medium-count": {} }
  end
end
