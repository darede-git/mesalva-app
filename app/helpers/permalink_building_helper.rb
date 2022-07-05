# frozen_string_literal: true

require 'me_salva/permalinks/builder'
module PermalinkBuildingHelper
  def build_permalinks(entity, level)
    builder = MeSalva::Permalinks::Builder.new(entity_id: entity.id,
                                              entity_class: entity.class.to_s)
    case level
    when :children
      builder.build_children_permalinks
    when :subtree
      builder.build_subtree_permalinks
    when :self
      builder.build_self_permalinks
    end
  end
end
