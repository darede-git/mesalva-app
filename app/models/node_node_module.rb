# frozen_string_literal: true

class NodeNodeModule < ActiveRecord::Base
  include PermalinkValidationHelper

  belongs_to :node
  belongs_to :node_module
end
