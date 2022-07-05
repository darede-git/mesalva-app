# frozen_string_literal: true

class User::PrepTestOverviewsController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def index
    @prep_test_overviews = index_with_like_filters
    if @prep_test_overviews
      render json: serialize(@prep_test_overviews), status: :ok
    else
      render_not_found
    end
  end

  private

  def index_with_like_filters
    PrepTestOverview.permalink_slug_like_by_user_uid(
      params[:user_uid], params[:permalink_slug]
    )
  end
end
