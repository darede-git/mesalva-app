# frozen_string_literal: true

class User::MentoringsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_mentorings

  def index
    render json: serialize(@mentoring, meta: meta), status: :ok
  end

  private

  def set_mentorings
    @mentoring = Mentoring.by_user(current_user)
                         .next_only_filter(next_only?)
                         .order(:starts_at)
                         .page(page_param)
                         .per_page(per_page_param(5))
  end

  def meta
    pagination_meta(@mentoring)
  end

  def next_only?
    params[:next_only] == 'true'
  end
end
