# frozen_string_literal: true

class MentoringsController < ApplicationController
  before_action :set_mentoring, except: %i[index create]
  before_action -> { authenticate(%w[admin]) }, except: %i[index show]

  def index
    mentoring = Mentoring.all
    render json: serialize(mentoring), status: :ok
  end

  def create
    @mentoring = Mentoring.new(mentoring_params)

    if @mentoring.save
      render json: serialize(@mentoring), status: :created
    else
      render_unprocessable_entity(@mentoring.errors)
    end
  end

  def update
    if @mentoring.update(mentoring_params)
      render json: serialize(@mentoring), status: :ok
    else
      render_unprocessable_entity(@mentoring.errors.messages)
    end
  end

  def show
    if @mentoring
      render json: serialize(@mentoring), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    if @mentoring.destroy
      render_no_content
    else
      render_unprocessable_entity(@mentoring.errors.messages)
    end
  end

  private

  def set_mentoring
    @mentoring = Mentoring.find_by_id(params[:id])
  end

  def mentoring_params
    params.permit(:title,
                  :status,
                  :user_id,
                  :content_teacher_id,
                  :comment,
                  :rating,
                  :starts_at,
                  :simplybook_id)
  end
end
