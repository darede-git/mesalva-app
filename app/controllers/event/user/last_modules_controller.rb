# frozen_string_literal: true

require 'will_paginate/array'

class Event::User::LastModulesController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def show
    return render_not_found if ENV['EVENTS_DISABLE'] == 'true'
    render json: { results: paginated_last_modules }
  end

  private

  def paginated_last_modules
    paginate MeSalva::Event::User::LastModulesCache
      .new(user_id: current_user.id)
      .cache(params[:education_segment]),
             per_page: ENV['PAGINATION_SIZE'] || 10
  end
end
