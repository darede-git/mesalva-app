# frozen_string_literal: true

module NodeModuleCountHelper
  extend ActiveSupport::Concern

  def node_module_count
    subtree.joins(:node_modules).count(:node_modules)
  end
end
