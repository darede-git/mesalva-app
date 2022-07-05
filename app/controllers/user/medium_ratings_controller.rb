# frozen_string_literal: true

class User::MediumRatingsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_medium_rating, only: :show

  def show
    if @medium_rating
      render json: serialize_legacy, status: :ok
    else
      render_not_found
    end
  end

  def create
    @medium_rating = MediumRating.new(medium_rating_params)
    if @medium_rating.save
      render json: serialize_legacy, status: :created
    else
      render_unprocessable_entity(@medium_rating.errors)
    end
  end

  private

  def medium_rating_params
    params
      .permit(:value)
      .merge(user: current_user)
      .merge(medium: Medium.find_by_slug(params[:medium_slug]))
  end

  def set_medium_rating
    @medium_rating = MediumRating
      .joins(:medium)
      .where({"user": current_user, "media.slug": params[:medium_slug]})
      .last
  end

  def serialize_legacy(medium_ratings = nil)
    medium_ratings ||= @medium_rating
    MediumRatingsSerializer.new(medium_ratings)
  end
end
