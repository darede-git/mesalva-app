# frozen_string_literal: true

class PermalinkBuildWorker
  include Sidekiq::Worker

  def perform(entity_id, entity_class)
    permalink_builder = MeSalva::Permalinks::Builder.new(
      entity_id: entity_id,
      entity_class: entity_class
    )
    permalink_builder.build_subtree_permalinks
  end
end
