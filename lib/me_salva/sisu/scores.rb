# frozen_string_literal: true

module MeSalva
  class Sisu
    class Scores

      MODALITIES_MAP = {
        carente: 4001,
        afro: 4002,
        publica: 4003,
        indigena: 4004,
        defifiencia: 4005,
        trans: 4006,
      }

      def initialize(quiz_form_submission, user_id)
        @form_submission = quiz_form_submission
        @user_id = user_id
        answers
      end

      def results
        create_sisu_score
        response
      end

      private

      def answers
        @answers = {}
        @form_submission.answers.each do |answer|
          if answer.quiz_question_id == 103
            if @answers[answer.quiz_question_id].nil?
              @answers[answer.quiz_question_id] = { }
            end
            @answers[answer.quiz_question_id][answer.quiz_alternative_id] = answer
          else
            @answers[answer.quiz_question_id] = answer
          end
        end
      end

      def course
        @answers[101].alternative.description
      end

      def state
        @answers[102].alternative.description&.split(' - ')&.last
      end

      def marked_modalities
        @answers[103]
      end

      def scores
        { cnat: cnat, chum: chum, ling: ling, mat: mat, red: red }
      end

      def chum
        @answers[104]&.value
      end

      def cnat
        @answers[105]&.value
      end

      def ling
        @answers[106]&.value
      end

      def mat
        @answers[107]&.value
      end

      def red
        @answers[108]&.value
      end

      def max_passing_score
        sisu_scores&.map { |s| s['passing_score'].to_f }.max
      end

      def min_passing_score
        sisu_scores&.map { |s| s['passing_score'].to_f }.min
      end

      def max_average
        sisu_scores&.map { |s| s['average'].to_f }.max
      end

      def min_average
        sisu_scores&.map { |s| s['average'].to_f }.min
      end

      def sisu_scores
        result ||= SisuInstitute.scores_by_state_ies(state, course, scores)
        @sisu_scores = {}

        result.each do |row|
          ies = row['ies']
          allowed = modality_allowed?(row)
          unless @sisu_scores[ies].present?
            @sisu_scores[ies] = row
            @sisu_scores[ies]['allowed'] = allowed
            @sisu_scores[ies]['chances'] = allowed && row['chances'] == true
            @sisu_scores[ies]['modalities'] = {}
          end
          @sisu_scores[ies]['modalities'][sanitized_modality(row['modality'])] = {}
          current_modality = @sisu_scores[ies]['modalities'][sanitized_modality(row['modality'])]
          current_modality['approval_prospect'] = row['approval_prospect']
          current_modality['average'] = row['average']
          current_modality['chances'] = allowed && row['chances'] == true
          current_modality['passing_score'] = row['passing_score']
          current_modality['semester'] = row['semester']
          current_modality['shift'] = row['shift']
          current_modality['modality'] = row['modality']
          current_modality['allowed'] = allowed

          if @sisu_scores[ies]['allowed'] != true && allowed
            @sisu_scores[ies]['allowed'] = true
            @sisu_scores[ies]['approval_prospect'] = row['approval_prospect']
            @sisu_scores[ies]['average'] = row['average']
            @sisu_scores[ies]['chances'] = allowed && row['chances'] == true
            @sisu_scores[ies]['passing_score'] = row['passing_score']
            @sisu_scores[ies]['semester'] = row['semester']
            @sisu_scores[ies]['shift'] = row['shift']
            @sisu_scores[ies]['modality'] = row['modality']
          end
        end
        @sisu_scores.values.map do |row|
          row['modalities'] = row['modalities'].values
          row
        end
      end

      def modality_not_marked?(modality_name)
        modality_id = MODALITIES_MAP[modality_name.to_sym]
        return true unless marked_modalities

        marked_modalities.key?(modality_id) == false
      end

      def modality_allowed?(row)
        return false if row['trans'] && modality_not_marked?('trans')
        return false if row['indigena'] && modality_not_marked?('indigena')
        return false if row['deficiencia'] && modality_not_marked?('deficiencia')
        return false if row['publica'] && modality_not_marked?('publica')
        return false if row['carente'] && modality_not_marked?('carente')
        return false if row['afro'] && modality_not_marked?('afro')
        true
      end

      def create_sisu_score
        CreateSisuScoreWorker.perform_async(@form_submission.id,
                                            @user_id,
                                            sisu_scores)
      end


      def sanitized_modality(modality)
        modality
          .downcase
          .gsub(/[áéíóúãẽĩõũàèìòùäëïöüâêîôûç,]/, '')
          .gsub(/(\s+|-)/, '_')
      end

      def response
        { scores: sisu_scores,
          max_passing_score: max_passing_score,
          max_average: max_average,
          min_passing_score: min_passing_score,
          min_average: min_average }
      end
    end
  end
end
