# frozen_string_literal: true

class NodeModuleItem < ActiveRecord::Base
  include PermalinkValidationHelper

  belongs_to :node_module
  belongs_to :item
end
