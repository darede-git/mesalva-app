# frozen_string_literal: true

class Permalink::CanonicalController < ApplicationController
  include AlgoliaIndex
  before_action -> { authenticate(%w[admin]) }
  before_action :set_permalink

  def update
    return render_not_found unless @permalink

    if @permalink.update(permalink_params)
      render json: @permalink,
             serializer: Permalink::PermalinkSerializer,
             status: :ok
    else
      render json: @permalink.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def permalink_params
    params.permit(:canonical_uri)
  end

  def set_permalink
    @permalink = Permalink.find_by_slug(params[:slug])
  end
end
