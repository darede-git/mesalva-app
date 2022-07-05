# frozen_string_literal: true

module MediumShowConcern
  include PermalinkAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :set_medium_by_slug, only: [:show]
    before_action :set_permalink_by_slug, only: [:show]
    before_action :validate_access, only: [:show]
  end

  def set_medium_by_slug
    @medium = Rails.cache.fetch(params[:slug], expire_in: 10.minutes) do
      Medium.find_by_slug(params[:slug])
    end
    return render_not_found if @medium.nil?
  end

  def set_permalink_by_slug
    @permalink = Rails.cache.fetch(params[:permalink_slug],
                                   expire_in: 10.minutes) do
      Permalink.find_by_slug(params[:permalink_slug])
    end
    return render_unprocessable_entity if @permalink.nil?
    return render_unprocessable_entity unless @permalink.medium_id == @medium.id
  end

  def validate_access
    return true if @permalink.viewable_to_guests?
    return true if @permalink.item.free && current_user.present?
    return true if permalink_access.validate(@permalink.node_ids, current_user)
    return render_payment_required if current_user.present?

    render_unauthorized
  end
end
