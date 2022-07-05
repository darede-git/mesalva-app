# frozen_string_literal: true

class LpPagesController < ApplicationController
  before_action -> { authenticate(%w[admin]) }
  before_action :set_lp_page, only: %i[show update destroy]

  def index
    lp_pages = LpPage.order(:id)
    render json: serialized_lp_page(lp_pages), status: :ok
  end

  def show
    if @lp_page
      render json: serialized_lp_page, status: :ok
    else
      render_not_found
    end
  end

  def update
    if @lp_page.update(lp_page_params)
      render json: serialized_lp_page, status: :ok
    else
      render_unprocessable_entity(@lp_page.errors.messages)
    end
  end

  def create
    @lp_page = LpPage.new(lp_page_params)

    if @lp_page.save
      render json: serialized_lp_page, status: :ok
    else
      render_unprocessable_entity(@lp_page.errors.messages)
    end
  end

  def destroy
    if @lp_page.update(active: false)
      render_no_content
    else
      render_unprocessable_entity(@lp_page.errors.messages)
    end
  end

  private

  def serialized_lp_page(entity = nil)
    serialize_legacy(entity || @lp_page, class: 'LpPage')
  end

  def set_lp_page
    @lp_page = LpPage.where(slug: params[:slug], active: true).order(created_at: 'DESC')
  end

  def lp_page_params
    params.permit(:name, :slug, :active, data: {}, schema: {})
  end
end
