# frozen_string_literal: true

class BasePermalinkController < ApplicationController
  abstract!
  before_action :set_permalink

  def set_permalink
    @permalink = Permalink
                 .find_by_slug_with_active_entities(params[:slug])
  end
end
