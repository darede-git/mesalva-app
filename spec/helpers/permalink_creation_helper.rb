# frozen_string_literal: true

module PermalinkCreationHelper
  def parsed_entities(entities = permalink_entities)
    list = create_factory_list(entities).flatten
    build_relations

    last_entity = entity_serializable_hash(last_entity_class_wrap(list.last))
    list[-1] = {}
    last_entity.map do |key, value|
      list[-1][key.to_s.dasherize.to_sym] = value
    end
    list.as_json
  end

  def build_relations
    permalink.reload
    build_node_ancestry if permalink_has_multiple_nodes?
    add_node_modules_to_node
    add_items_to_node_module
    add_medium_to_item
  end

  def build_node_ancestry
    add_parent_to_node_by_index(0, 1)
    add_parent_to_node_by_index(1, 2) if permalink.nodes.length > 2
  end

  def permalink_has_multiple_nodes?
    permalink.nodes.length > 1
  end

  def add_medium_to_item
    return if permalink.medium.nil?

    permalink.item.medium_ids = [permalink.medium.id]
    permalink.item.save
  end

  def add_items_to_node_module
    return if permalink.item.nil?

    permalink.node_module.item_ids = [permalink.item.id]
    permalink.node_module.save
  end

  def add_node_modules_to_node
    return if permalink.node_module.nil?

    permalink.nodes.last.node_module_ids = [permalink.node_module.id]
    permalink.nodes.last.save
  end

  def add_parent_to_node_by_index(parent, node)
    permalink.nodes[node].parent = permalink.nodes[parent]
    permalink.nodes[node].save
  end

  def create_factory_list(entities)
    entities.keys.each_with_object([]) do |entity, list|
      values = entities[entity]
      list.push(
        JSON.parse(FactoryBot
        .create_list(entity, values[0], permalink_ids: [permalink.id])
        .to_json(only: values[1]))
        .each { |e| e.merge!('entity-type' => entity.to_s) }
      )
    end
  end

  def permalink_entities_medium(medium_qt = 1)
    { node: [2, %i[id name color_hex slug]],
      node_module: [1, %i[id name color_hex slug]],
      item: [1, %i[id name]],
      medium: [medium_qt, %i[id name]] }
  end

  def permalink_entities
    { node: [2, %i[id name color_hex slug]],
      node_module: [1, %i[id name color_hex slug]],
      item: [1, %i[id name]] }
  end

  def permalink_entities_module
    {
      node: [2, %i[id name color_hex slug]],
      node_module: [2, %i[id name color_hex slug]]
    }
  end

  def permalink_entities_node
    {
      node: [3, %i[id name color_hex slug]]
    }
  end

  def parsed_structure(body, node)
    JSON.parse(body)[node]
  end
end
