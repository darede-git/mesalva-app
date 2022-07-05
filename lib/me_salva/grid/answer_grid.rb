# frozen_string_literal: true

require 'open-uri'

module MeSalva
  class Grid
    class AnswerGrid
      def initialize(quiz_form_submission, user_id)
        @answers = quiz_form_submission.answers.reload
        @user_id = user_id
        @url = "#{ENV['S3_CDN']}/data/lps/enem-answer-key"
        @answer_grid = {}
        @submission = quiz_form_submission
      end

      def check
        create_enem_answer_grid
        compare_questions
      end

      def file_exists?
        file.success?
      end

      private

      def compare_questions
        total_correct_answer = 0
        answers_valid.each do |answer|
          @answer = answer
          total_correct_answer += 1 if correct?
          populate_answer_grid
          create_enem_answer
        end
        @answer_grid.merge!(answers_correct: total_correct_answer,
                            exam: exam_name)
      end

      def correct?
        answer_value == correct_answer_value
      end

      def answers_valid
        @answers.reject do |a|
          [52, 53, 110, 111].include?(a.quiz_question_id)
        end
      end

      def answer_value
        @answer.alternative.value
      end

      def correct_answer_value
        correct_answers[@answer.quiz_question_id - 6]
      end

      def correct_answers
        @correct_answers ||= JSON.parse(file.body)
      end

      def file
        @file ||= HTTParty.get(@url + file_name)
      end

      def file_name
        "/#{year}/#{exam_name}#{language}_#{exam_color}.json"
      end

      def exam_name
        @exam_name ||= find_alternative_value_with_question_id(52)
      end

      def exam_color
        @exam_color ||= find_alternative_value_with_question_id(53)
      end

      def language
        @language ||= find_alternative_value_with_question_id(110)
      end

      def year
        @year ||= @answers.find { |a| a['quiz_question_id'] == 111 }.try(:value)
      end

      def find_alternative_value_with_question_id(id)
        answer = @answers.find { |a| a['quiz_question_id'] == id }
        answer&.alternative&.value
      end

      def populate_answer_grid
        @answer_grid.merge!(@answer.quiz_question_id =>
          { 'correct' => correct?,
            'answer' => correct_answer_value,
            'alternative-id' => @answer.alternative.id })
      end

      def create_enem_answer
        ::Enem::Answer.create!(question: @answer.question,
                               value: answer_value,
                               alternative: @answer.alternative,
                               correct_value: correct_answer_value,
                               correct: correct?,
                               answer_grid: @enem_answer_grid)
      end

      def create_enem_answer_grid
        @enem_answer_grid = ::Enem::AnswerGrid.create!(enem_answer_grid_attr)
      end

      def enem_answer_grid_attr
        { exam: exam_name, language: language, color: exam_color,
          user_id: @user_id, year: year, form_submission: @submission }
      end
    end
  end
end
