# frozen_string_literal: true

class Bff::User::ExercisesController < Bff::User::BffUserBaseController

  def submitted_prep_test_exercise
    return not_found unless set_medium

    set_event
    set_answers
    render_results(medium_text: @medium.medium_text,
                   correction: @medium.correction,
                   difficulty: @medium.difficulty,
                   video_id: @medium.video_id,
                   provider: @medium.provider,
                   answered_id: @event&.answer_id,
                   correct: @event&.correct,
                   answered_at: @event&.created_at,
                   answers: @answers,
                   answered_letted: @answered_letted,
                   correct_answer_letter: @correct_letter,
    )
  end

  private

  def set_event
    @event = ExerciseEvent.where(medium_slug: params[:medium_slug], submission_token: params[:submission_token], user_id: current_user.id).last
  end

  def set_medium
    @medium = Medium.find_by_slug(params[:medium_slug])
  end

  def set_answers
    index = -1
    letters = 'ABCDE'
    @answered_letted = nil
    @correct_letter = nil
    @answers = @medium.answers.map do |answer|
      index += 1
      answered = answer.id == @event&.answer_id
      letter = letters[index]
      @answered_letted = letter if answered
      @correct_letter = letter if answer.correct
      {
        letter: letter,
        correct: answer.correct,
        text: answer.text,
        explanation: answer.explanation,
        answered: answered,
      }
    end
  end
end
