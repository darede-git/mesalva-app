# frozen_string_literal: true

class TestimonialsController < ApplicationController
  before_action -> { authenticate(%w[admin]) },
                only: %i[create update destroy]
  before_action :set_testimonial_by_education_segment_slug, only: [:show]
  before_action :set_testimonial_by_id, only: %i[update destroy]

  include AuthorshipConcern

  def index
    render_ok(testimonials)
  end

  def show
    if @testimonial
      render json: @testimonial, status: :ok
    else
      render_not_found
    end
  end

  def destroy
    @testimonial.destroy
    render_no_content
  end

  def update
    if @testimonial.update(testimonial_parameters)
      render json: @testimonial, status: :ok
    else
      render_unprocessable_entity
    end
  end

  def create
    testimonial = Testimonial.new(testimonial_parameters)
    if testimonial.save
      render json: testimonial, status: :created
    else
      render_unprocessable_entity
    end
  end

  private

  def testimonial_parameters
    params.merge(attribute => current_admin.uid)
          .permit(:text, :avatar, :created_by,
                  :updated_by, :user_name, :education_segment_slug,
                  :email, :phone, :sts_authorization,
                  :marketing_authorization)
  end

  def testimonials
    Testimonial.all
  end

  def set_testimonial_by_education_segment_slug
    @testimonial = Testimonial.find_by(education_segment_slug:
      params[:education_segment_slug])
  end

  def set_testimonial_by_id
    @testimonial = Testimonial.find_by_token(params[:id])
  end
end
