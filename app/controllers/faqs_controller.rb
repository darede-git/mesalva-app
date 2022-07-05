# frozen_string_literal: true

class FaqsController < ApplicationController
  before_action -> { authenticate(%w[admin]) },
                only: %i[create update destroy]
  before_action :set_faq_by_token, only: %i[update destroy]

  include AuthorshipConcern

  def index
    if params.key?(:slug)
      render json: set_faqs_by_slug, include: :questions, status: :ok
    else
      render json: Faq.all, status: :ok
    end
  end

  def create
    faq = Faq.new(faq_params)
    if faq.save
      render json: faq, include: :questions, status: :created
    else
      render_unprocessable_entity
    end
  end

  def update
    if @faq.update(faq_params)
      render json: @faq, include: :questions, status: :ok
    else
      render_unprocessable_entity
    end
  end

  def destroy
    @faq.destroy
    render_no_content
  end

  private

  def set_faq_by_token
    @faq = Faq.find_by_token(params[:id])
  end

  def set_faqs_by_slug
    Faq.where(slug: params[:slug])
  end

  def faq_params
    params.permit(:slug, :name, :created_by, :updated_by)
  end
end
