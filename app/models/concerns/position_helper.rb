# frozen_string_literal: true

module PositionHelper
  extend ActiveSupport::Concern

  included do
    before_create :set_position
  end

  def set_position
    self.position = next_position
  end

  def next_position
    return position unless position.nil?

    return 1 if parent.nil?

    self.position = parent.last_child_position.to_i + 1
  end
end
