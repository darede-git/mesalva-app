# frozen_string_literal: true

class Permalink::SuggestionsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_permalink_suggestions, only: [:index]

  def index
    render json: @permalink_suggestions, status: :ok
  end

  private

  def set_permalink_suggestions
    @permalink_suggestions = PermalinkSuggestion.where(slug: params['slug'])
  end
end
