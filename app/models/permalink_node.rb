# frozen_string_literal: true

class PermalinkNode < ActiveRecord::Base
  include PositionHelper

  default_scope { order(:position) }

  belongs_to :permalink, dependent: :destroy
  belongs_to :node

  validates :permalink, :node, presence: true, allow_blank: false

  def next_position
    Permalink.find(permalink.id).permalink_nodes.count + 1
  end
end
