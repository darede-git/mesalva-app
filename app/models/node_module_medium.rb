# frozen_string_literal: true

class NodeModuleMedium < ActiveRecord::Base
  belongs_to :node_module
  belongs_to :medium
end
