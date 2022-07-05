# frozen_string_literal: true

module ActiveRelativesConcern
  extend ActiveSupport::Concern

  def node_modules
    object.node_modules.active.listed
  end

  def items
    object.items.active.listed
  end

  def media
    object.media.active.listed
  end
end
