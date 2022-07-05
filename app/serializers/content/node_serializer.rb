# frozen_string_literal: true

class Content::NodeSerializer < BaseNodeSerializer
  include ::ActiveRelativesConcern

  has_many :node_modules,
           key: 'node-modules',
           serializer: Content::Relation::NodeNodeModuleSerializer

  has_many :media, serializer: Content::Relation::ChildMediumSerializer

  attributes :children, :entity_type, :meta_title, :meta_description, :options

  private

  def relatives_serializer
    Content::Relation::NodeRelativesSerializer
  end
end
