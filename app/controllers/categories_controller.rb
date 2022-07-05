# frozen_string_literal: true

require 'me_salva/videos'

class CategoriesController < ApplicationController
  before_action -> { authenticate(%w[admin]) }

  def index
    render_ok(categories)
  end

  def show
    render_ok(medias)
  end

  private

  def categories
    videos.categories
  end

  def medias
    videos.medias(params[:id])
  end

  def videos
    @videos ||= MeSalva::Videos.new
  end
end
