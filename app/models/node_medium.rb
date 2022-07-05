# frozen_string_literal: true

class NodeMedium < ActiveRecord::Base
  belongs_to :node
  belongs_to :medium
end
