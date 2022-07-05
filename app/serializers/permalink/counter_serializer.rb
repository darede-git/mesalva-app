# frozen_string_literal: true

class Permalink::CounterSerializer < ActiveModel::Serializer
  attribute :permalink_counter, key: 'permalink-counter'

  def permalink_counter
    permalink_counter_hash
  end

  private

  def permalink_counter_hash
    @serializable_hash = response_for(object)
    return @serializable_hash if medium

    return counter_with_relationship if item || node_module

    counter_with_children
  end

  def counter_with_relationship
    return @serializable_hash.merge!(media_hash) if item

    @serializable_hash.merge!(items_hash)
  end

  def counter_with_children
    return @serializable_hash.merge!(node_modules_hash) \
      if node.node_modules.any?

    @serializable_hash.merge!(children_hash) if children.any?
  end

  def response_for(entity)
    { 'slug' => slug_for(entity) }
      .merge(seconds_duration(entity))
      .merge(node_module_count(entity))
      .merge(medium_count(entity))
  end

  def children_hash
    { 'children' => hash_list_for(children) }
  end

  def node_modules_hash
    return { 'node-modules' => [] } unless node.node_modules

    { 'node-modules' => hash_list_for(node.node_modules) }
  end

  def items_hash
    return { 'items' => [] } unless node_module.items

    { 'items' => hash_list_for(node_module.items) }
  end

  def media_hash
    return { 'media' => [] } unless medium

    { 'media' => hash_list_for([medium]) }
  end

  def hash_list_for(entities)
    entities.each_with_object([]) do |entity, list|
      list.push(response_for(entity))
    end
  end

  def seconds_duration(entity = object)
    { 'seconds-duration' => entity.try(:seconds_duration) }
  end

  def node_module_count(entity = object)
    counter = entity.try(:node_module_count) || 0
    { 'node-module-count' => counter }
  end

  def medium_count(entity = object)
    counters = entity.try(:medium_count)
    return { 'medium-count' => {} } unless counters

    { 'medium-count' => dasherized_keys_for(counters) }
  end

  def dasherized_keys_for(counters)
    counters.transform_keys { |k| k.try(:dasherize) }
  end

  def item
    @item ||= object.permalink.item
  end

  def medium
    @medium ||= object.permalink.medium
  end

  def node_module
    @node_module ||= object.permalink.node_module
  end

  def node
    @node ||= object.permalink.nodes.last
  end

  def children
    @children ||= node.children
  end

  def slug_for(entity)
    return entity.permalink.slug if entity.try(:permalink)

    entity.slug
  end
end
