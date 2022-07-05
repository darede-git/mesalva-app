# frozen_string_literal: true

class User::PrepTestDetailsController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def index
    @prep_test_details = PrepTestDetail.prep_test_detail_where_token(
      params[:token]
    )
    if @prep_test_details.empty?
      render_not_found
    else
      render json: serialize(@prep_test_details), status: :ok
    end
  end
end
