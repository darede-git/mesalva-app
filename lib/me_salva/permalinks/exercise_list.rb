# frozen_string_literal: true

module MeSalva
  module Permalinks
    class ExerciseList
      def initialize(permalink_slug)
        @permalink_slug = permalink_slug
      end

      def results
        media.map do |medium|
          {
            statement: medium.medium_text,
            difficulty: medium.difficulty,
            answers: answers(medium),
            correct: @correct
          }
        end
      end

      private

      def media
        permalink = ::Permalink.find_by_slug(@permalink_slug)
        item = permalink.item
        item.media
      end

      def answers(medium)
        medium.answers.each_with_index.map do |answer, index|
          letter = (65 + index).chr
          @correct = letter if answer.correct
          {
            text: answer.text,
            letter: letter
          }
        end
      end
    end
  end
end
