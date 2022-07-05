# frozen_string_literal: true

module PermalinkAssertionHelper
  def medium_types
    Medium::ALLOWED_TYPES.map(&:dasherize)
  end

  def assert_entity_medium_count(entity)
    expect(entity['medium-count']['video']).to eq 1
    (medium_types - ['video']).each do |medium_type|
      expect(entity['medium-count'][medium_type]).to eq 0
    end
  end

  def assert_entity_counters(entity)
    expect(entity.keys).to include 'medium-count', 'seconds-duration'
  end

  def assert_entity_medium_count_types(entity)
    expect(entity['medium-count'].keys).to match(medium_types)
  end

  def assert_last_entity_child_medium_count(child_entity)
    response_last_entity[child_entity].each do |child|
      assert_entity_medium_count_types(child)
      assert_entity_medium_count(child)
    end
  end

  def assert_permalink_inclusion(permalink, entities_permalinks)
    entities_permalinks.each do |entity_permalinks|
      expect(entity_permalinks).to include permalink
    end
  end

  def slug_for(entities)
    entities.map(&:slug).join('/')
  end

  def assert_permalink_entities_inclusion(permalink, ids)
    ids.map do |k, v|
      if v.is_a? Array
        expect(permalink.public_send(entity_key(k))).to match_array(v)
      else
        expect(permalink.public_send(entity_key(k))).to eq(v)
      end
    end
  end

  def entity_key(entity)
    return 'node_ids' if entity.to_s == 'node'

    "#{entity}_id"
  end

  def parents_for(entity)
    ed_segment = create(:node)
    node = create(:node_area, parent_id: ed_segment.id)
    if entity.instance_of?(NodeModule)
      node.node_module_ids = [entity.id]
    elsif entity.instance_of?(Item)
      node_module = create(:node_module)
      node.node_module_ids = [node_module.id]
      node_module.item_ids = [entity.id]
    end
    { education_segment: ed_segment, node: node, node_module: node_module }
  end

  def assert_permalink_last_entity_relation_not_to_have_keys(relation, keys)
    keys.each do |key|
      assert_permalink_last_entity_relation_not_to_have_key(relation, key)
    end
  end

  def assert_permalink_last_entity_relation_not_to_have_key(relation, key)
    relations = [response_last_entity[relation]].flatten
    relations.each do |item|
      expect(item).not_to have_key key
    end
  end

  def last_entity_class_wrap(last_entity)
    entity_class = last_entity.delete('entity-type').camelize.constantize
    entity_class.find(last_entity['id'])
  end

  def response_last_entity
    JSON.parse(response.body)['meta']['entities'].last
  end

  def entity_attributes(entity_id, entity_class, options = {})
    deep_key_fix(
      entity_serializable_hash(entity_class.find(entity_id), options)
    )
  end

  def deep_key_fix(entity)
    entity.deep_transform_keys do |key|
      key.to_s.dasherize
    end
  end

  def deep_array_key_fix(array)
    array.map do |obj|
      deep_key_fix(obj)
    end
  end

  def assert_unauthorized
    expect(parsed_response['errors'])
      .to include t('devise.failure.unauthenticated')
    assert_type_and_status(:unauthorized)
  end
end
