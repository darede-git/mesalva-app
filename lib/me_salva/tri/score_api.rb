# frozen_string_literal: true

module MeSalva
  module Tri
    class ScoreApi
      def initialize(answers, item)
        @answers = answers
        @item = item
        @tri_reference = item.tri_reference
      end

      def tri_score
        create_response
        raise_unless_valid_response_status
        JSON.parse(@response)['predicted_score']
      end

      private

      def tri_body
        { 'answers': answers_from_meta, 'blueprint': blueprint }
      end

      def answers_from_meta
        return @answers.map { |answer| answer['correct'] } if @item.options.nil? || @item.options['triMapper'].nil?

        answers_reordered
      end

      def answers_reordered
        mapper = {}
        @item.options['triMapper'].each_with_index do |answer, index|
          mapper[index+1] = answer
        end

        parsed_answers = []
        @answers.each_with_index do |answer, index|
          mapper_index = index + @item.options['offset'] + 1
          mapped = mapper[mapper_index]
          new_index = mapped - @item.options['offset'] - 1
          parsed_answers[new_index] = answer['correct']
        end
        parsed_answers
      end

      def blueprint
        { 'year': @tri_reference.year,
          'test': @tri_reference.exam }.merge!(language)
      end

      def language
        return {} unless @tri_reference.methods.include?(:language)
        return {} if @tri_reference.language.nil?

        { 'language': @tri_reference.language }
      end

      def create_response
        @response = HTTParty.post(
          "#{tri_api_url}predict",
          body: tri_body.to_json,
          headers: {
            'Content-Type' => 'application/json'
          }
        )
      end

      def raise_unless_valid_response_status
        return true if valid_response?

        raise MeSalva::Error::TriApiConnectionError.new(
          @response.code,
          @response.parsed_response
        )
      end

      def valid_response?
        @response.code == 200
      end

      def tri_api_url
        ENV['TRI_API_URL']
      end
    end
  end
end
