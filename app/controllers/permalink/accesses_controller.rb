# frozen_string_literal: true

require 'me_salva/permalinks/access'

class Permalink::AccessesController < BasePermalinkController
  before_action -> { authenticate(%w[admin user]) }
  before_action :prepare_permalink_access, only: :show

  def show
    if @permalink
      return render_permalink_access_v2 if v2?

      render_permalink_access_v1
    else
      render_bad_request
    end
  end

  private

  def render_permalink_access_v2
    render json: serialize_legacy(@permalink_access, class: 'V2::Permalink::Access'),
           status: :ok
  end

  def render_permalink_access_v1
    render json: @permalink_access,
           status: :ok,
           message: 'Deprecated API Resource',
           serializer: ::Permalink::AccessSerializer,
           adapter: :attributes
  end

  def prepare_permalink_access
    @permalink_access = MeSalva::Permalinks::Access.new(
      user: current_user, permalink: @permalink
    )
  end
end
