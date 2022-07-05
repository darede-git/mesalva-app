# frozen_string_literal: true

require 'me_salva/permalinks/builder'
module PermalinkBuildConcern
  extend ActiveSupport::Concern

  included do
    after_action :build_permalinks, only: %i[update create]
  end

  def build_permalinks
    return unless entity.valid?

    PermalinkBuildWorker.perform_async(entity.id, entity.class.to_s)
  end

  def entity
    @item || @node_module || @node
  end
end
