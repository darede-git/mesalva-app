# frozen_string_literal: true

class PrepTestsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_prep_test, only: :show

  def show
    if @prep_test
      render json: serialize(@prep_test), status: :ok
    else
      render_not_found
    end
  end

  private

  def set_prep_test
    @prep_test = PrepTest.find_by_permalink_slug(params['permalink_slug'])
  end
end
