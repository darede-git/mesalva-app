# frozen_string_literal: true

class Bff::User::ContentsController < Bff::User::BffUserBaseController
  before_action :set_medium, only: %i[show_video show_rating show_text]

  def show_video
    render_results({ video_id: @medium.video_id })
  end

  def show_text
    render_results({ html: @medium.medium_text })
  end

  def show_rating
    last_rating = MediumRating.where(user_id: current_user.id, medium_id: @medium.id).last
    return render_results({ default_value: 0 }) if last_rating.nil?

    render_results({ default_value: last_rating.value })
  end

  def exercise_answered
    # TODO salvar exercício resovido dentro do item (:item_token/:medium_token)
    # TODO salvar aula assistida dentro do módulo (:node_module_token/:item_token)
    render_no_content
  end

  private

  def set_medium
    @medium = Medium.find_by_token(params[:token]) #TODO validar se a pessoa tem acesso a esta aula
  end
end
