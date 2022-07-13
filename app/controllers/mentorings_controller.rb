# frozen_string_literal: true

class MentoringsController < ApplicationController
  before_action :authenticate_permission
  before_action :set_mentoring, except: %i[index create]

  def index
    render json: serialize(filtered_mentorings), status: :ok
  end

  def create
    @mentoring = Mentoring.new(create_mentoring_params)
    return render_unprocessable_entity(@mentoring.errors.messages) unless @mentoring.save

    render json: serialize(@mentoring), status: :created
  end

  def update
    return render_unprocessable_entity(@mentoring.errors.messages) unless @mentoring.update(update_mentoring_params)

    render json: serialize(@mentoring), status: :ok
  end

  def show
    render json: serialize(@mentoring), status: :ok
  end

  def destroy
    return render_unprocessable_entity(@mentoring.errors.messages) unless @mentoring.update(active: !@mentoring.active)

    render_no_content
  end

  private

  def set_mentoring
    @mentoring = Mentoring.find_by_id(params[:id])
    render_not_found if @mentoring.nil?
  end

  def filtered_mentorings
    @filter_params = params.permit(:like_title, :category, :active, :content_teacher_id)
    add_user_filter
    add_content_teacher_filter

    Mentoring
      .ms_filters(@filter_params)
      .next_only_filter(next_param_only?)
      .page(page_param)
      .order(order_by_param)
  end

  def add_user_filter
    return nil if params[:user_uid].blank?

    @filter_params.merge!(user_id: user_by_uid_param.id)
  end

  def user_by_uid_param
    @user_by_uid_param ||= User.find_by_uid(params[:user_uid])
  end

  def add_content_teacher_filter
    return nil if params[:like_content_teacher_name].blank?

    content_teacher_ids = ContentTeacher.where("name ILIKE ?", "%#{params[:like_content_teacher_name]}%").pluck(:id)
    @filter_params.merge!(content_teacher_id: content_teacher_ids)
  end

  def next_param_only?
    params[:next_only] == 'true'
  end

  def order_by_param
    return 'starts_at' if params[:order_by].nil?

    params[:order_by]
  end

  def create_mentoring_params
    update_mentoring_params.merge(user: user_by_uid_param)
  end

  def update_mentoring_params
    update_params = mentoring_params.clone
    update_params.merge!(starts_at: update_starts_at_param) if params[:starts_at].present?
    update_params.merge!(content_teacher: content_teacher_param) if params[:content_teacher_email].present?
    update_params
  end

  def content_teacher_param
    ContentTeacher.find_by_email(params[:content_teacher_email])
  end

  def update_starts_at_param
    starts_at = DateTime.parse(params[:starts_at])
    starts_at + ENV['TIME_ZONE_OFFSET_HOURS'].to_i.hours
  end

  def mentoring_params
    @mentoring_params ||= params.permit(:title, :content_teacher_id, :comment, :category,
                                        :rating, :starts_at, :call_link, :simplybook_id)
  end
end
