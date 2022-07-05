# frozen_string_literal: true

class Permalink::NodeSerializer < BaseNodeSerializer
  include ::ActiveRelativesConcern

  has_many :node_modules,
           key: 'node-modules',
           serializer: Permalink::Relation::NodeNodeModuleSerializer

  has_many :media, serializer: Permalink::Relation::ChildMediumSerializer

  attributes :children, :node_module_count, :entity_type, :medium_count,
             :seconds_duration, :listed

  private

  def relatives_serializer
    Permalink::Relation::NodeRelativesSerializer
  end
end
