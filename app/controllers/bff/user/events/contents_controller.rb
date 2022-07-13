# frozen_string_literal: true

class Bff::User::Events::ContentsController < Bff::User::BffUserBaseController
  before_action :set_medium

  def index_sidebar_events
    @node_module = NodeModule.find_by_token(params[:node_module_token])
    @events = []
    LessonEvent.where(user: current_user, node_module_slug: @node_module.slug).each do |event|
      @events << {
        id: event.item_slug
      }
      ExerciseEvent.where(user: current_user, item_slug: event.item_slug).each do |exercise_event|
        @events << {
          id: exercise_event.medium_slug,
          is_correct: exercise_event.correct,
          is_answered: true,
          show_answer: true,
        }
      end
    end
    @events

    render_results(@events)
  end

  def create_exercise_event
    @item = Item.find_by_token(params[:item_token])
    @node_module = NodeModule.find_by_token(params[:node_module_token])
    LessonEvent.create(user: current_user, item_slug: @item.slug, node_module_slug: @node_module.slug)

    answer = Answer.find(params[:id])
    ExerciseEvent.create(user: current_user, item_slug: @item.slug, medium_slug: @medium.slug,
                         correct: answer.correct, answer_id: params[:id], position: 0)
    render_no_content
  end

  def list_exercise_answers

    render_no_content
  end

  def show_medium_rating
    @rating = MediumRating.where(user: current_user, medium: @medium).last
    return render_results({ value: 0 }) if @rating.nil?

    render_results({ value: @rating.value })
  end

  def create_medium_rating
    return render_unprocessable_entity if params[:value].nil?

    @rating = MediumRating.create(user: current_user, medium: @medium, value: params[:value])
    render_results({ value: @rating.value })
  end

  private

  def set_medium
    @medium = Medium.find_by_token(params[:token])
  end
end
