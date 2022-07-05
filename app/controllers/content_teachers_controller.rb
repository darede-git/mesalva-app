# frozen_string_literal: true

class ContentTeachersController < ApplicationController
  before_action :set_content_teacher, except: %i[index create]
  before_action :authenticate_permission, except: %i[show]

  def index
    @content_teachers = ContentTeacher.filters(filter_params)
                                      .page(page_param)
                                      .per_page(per_page_param)
    render json: serialize(@content_teachers, v: 3), status: :ok
  end

  def create
    @content_teacher = ContentTeacher.new(content_teacher_params)
    if @content_teacher.save
      render json: serialize(@content_teacher, v: 3), status: :created
    else
      render_unprocessable_entity(@content_teacher.errors)
    end
  end

  def update
    if @content_teacher.update(content_teacher_params)
      render json: serialize(@content_teacher, v: 3), status: :ok
    else
      render_unprocessable_entity(@content_teacher.errors.messages)
    end
  end

  def show
    if @content_teacher
      render json: serialize(@content_teacher, v: 3), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    return render_no_content if @content_teacher.update(active: false)

    render_unprocessable_entity(@content_teacher.errors.messages)
  end

  private

  def filter_params
    params.permit(:name, :slug, :email, :content_type, :like_name,
                  :like_email, :like_content_type, :active)
  end

  def set_content_teacher
    @content_teacher = ContentTeacher.find_by_slug(params[:slug])
    return render_not_found unless from_current_teacher
  end

  def from_current_teacher
    return false unless @user_platform&.platform == @platform

    true
  end

  def content_teacher_params
    params.permit(:name, :slug, :active, :image, :email, :avatar, :description, :content_type)
  end
end
