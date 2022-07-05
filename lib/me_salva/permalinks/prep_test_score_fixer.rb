# frozen_string_literal: true

module MeSalva
  module Permalinks
    class PrepTestScoreFixer
      def fix_test(test_slug, offset = 0)
        limit = 500
        PrepTestOverview.where(permalink_slug: "enem-e-vestibulares/simulados/#{test_slug}").offset(offset).limit(limit).each do |pto|
          fix_by_prep_test_overview(pto)
        end
      end

      def fix_by_prep_test_overview(pto)
        event_answers_by_medium_slug = {}
        event_answers_by_answer_id = {}
        event_positions = []
        corrects = 0
        ExerciseEvent.where(submission_token: pto.token).each do |event|
          next if event.answer_id.nil?
          correct = Answer.find(event.answer_id).correct
          event_answers_by_medium_slug[event.medium_slug] = correct
          event_positions << {id: event.id, medium_slug: event.medium_slug}

          answer = Answer.find(event.answer_id); 0
          medium_by_answer = answer.medium
          event_answers_by_answer_id[medium_by_answer.slug] = {
            "event-id" => event.id,
            "slug" => medium_by_answer.slug,
            "answer-id" => answer.id,
            "correct" => answer.correct,
            "correction" => medium_by_answer.correction,
            "medium-text" => medium_by_answer.medium_text,
            "answer-correct" => medium_by_answer.correct_answer_id,
            "submission-token" => pto.token,
          }

          if correct != event.correct
            puts "#{event.id} from: #{event.correct} => #{correct}"
            event.update(correct: correct); 0
          end
          corrects += 1 if correct
        end;0
        event_positions.sort_by {|event| event[:medium_slug].sub('sim20221cn9', 'sim20221cn09')}.each_with_index do |event, index|
          ExerciseEvent.where(id: event[:id]).update(position: index); 0
        end
        answers = event_answers_by_answer_id.values.sort_by {|answer| answer['slug'].sub('sim20221cn9', 'sim20221cn09')}
        answers.each_with_index do |answer, index|
          ExerciseEvent.where(id: answer["event-id"]).update(position: index, medium_slug: answer['slug'], answer_id: answer['answer-id']); 0
        end

        item = Permalink.find_by_slug(pto.permalink_slug).item

        begin
          score = MeSalva::Tri::ScoreApi.new(answers, item).tri_score
          PrepTestScore.where(submission_token: pto.token).update(score: score); 0
          pto.score = score
        rescue StandardError
        end

        pto.corrects = corrects
        pto.answers = answers;''
        pto.save; ''
      end

      def fix_batch(test_slug, range = 0...15)
        for i in range do
          fix_test(test_slug, i*500)
        end
      end
    end
  end
end
