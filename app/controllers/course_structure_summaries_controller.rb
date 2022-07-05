# frozen_string_literal: true

class CourseStructureSummariesController < ApplicationController
  before_action -> { authenticate(%w[admin]) },
                only: %i[update create destroy]
  before_action :set_course_structure_summary, only: %i[show update destroy]

  def index
    render json: serialize(listed_course_structures_summary), status: :ok
  end

  def show
    render json: serialize(@course_structure_summary), status: :ok
  end

  def create
    @course_structure_summary =
      CourseStructureSummary.new(course_structure_summary_params)
    if @course_structure_summary.save
      render_created(@course_structure_summary)
    else
      render json: @course_structure_summary.errors.messages,
             status: :unprocessable_entity
    end
  end

  def update
    if @course_structure_summary.update(course_structure_summary_params)
      render json: @course_structure_summary, status: :ok
    else
      render_unprocessable_entity
    end
  end

  def destroy
    @course_structure_summary.destroy
    render_no_content
  end

  private

  def set_course_structure_summary
    @course_structure_summary = if admin_signed_in?
                                  course_structure_summary_by_id
                                else
                                  course_structure_summary
                                end
    render_not_found unless @course_structure_summary
  end

  def course_structure_summary_params
    params.permit(:id, :name, :slug, :active, :listed, :highlighted, :position,
                  :is_single_template, :per_page, selling_banner_params,
                  events_params, panel_highlights_params, essay_params,
                  description_card_params)
  end

  def selling_banner_params
    %i[selling_banner_name
       selling_banner_slug
       selling_banner_background_color
       selling_banner_background_image
       selling_banner_price_subtitle
       selling_banner_base_price
       selling_banner_checkout_button_label
       selling_banner_video
       selling_banner_infos
       selling_banner_package_slug
       selling_banner_checkout_link]
  end

  def events_params
    %i[events_title events_contents]
  end

  def panel_highlights_params
    %i[panel_highlights_image
       panel_highlights_color
       panel_highlights_name
       panel_highlights_button_text
       panel_highlights_premium_button_text]
  end

  def essay_params
    %i[essay_text essay_permalink]
  end

  def description_card_params
    %i[description_card_hide
       description_card_title
       description_card_image
       description_card_text
       description_card_cta_href
       description_card_cta_text
       description_card_cta_premium_text]
  end

  def listed_course_structures_summary
    CourseStructureSummary.where(listed: true)
  end

  def course_structure_summary
    CourseStructureSummary.find_by_slug(params['slug'])
  end

  def course_structure_summary_by_id
    return nil unless params['id']

    CourseStructureSummary.find(params['id'])
  end
end
