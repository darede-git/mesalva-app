# frozen_string_literal: true

class Bff::User::Events::ContentsController < Bff::User::BffUserBaseController
  def exercise_answered
    # TODO salvar exercício resovido dentro do item (:item_token/:medium_token)
    # TODO salvar aula assistida dentro do módulo (:node_module_token/:item_token)
    binding.pry
    render_no_content
  end

  def show_medium_rating
    set_medium

    @rating = MediumRating.where(user: current_user, medium: @medium).last
    return render_results({ value: 0 }) if @rating.nil?

    render_results({ value: @rating.value })
  end

  def create_medium_rating
    return render_unprocessable_entity if params[:value].nil?

    set_medium
    @rating = MediumRating.create(user: current_user, medium: @medium, value: params[:value])
    render_results({ value: @rating.value })
  end

  private

  def set_medium
    @medium = Medium.find_by_token(params[:token])
  end
end
