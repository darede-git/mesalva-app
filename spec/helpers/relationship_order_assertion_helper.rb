# frozen_string_literal: true

module RelationshipOrderAssertionHelper
  include RelativesPositionHelper

  def assert_relationship_id_ordering(entity, relation)
    entities = create_entity_with_many_relationships(entity, relation)
    @entity = entities[:entity]
    expected_ids = entities[:relationship_ids]
    expect(entity_relative_ids).to eq expected_ids
    shuffled_ids = shuffle_related_entities(@entity)
    @entity.reload
    expect(entity_relative_ids).to eq shuffled_ids
  end

  def assert_relationship_inclusion_and_ordering(entity)
    @entity = entity
    positions = entity_relative_positions
    expect(positions).to contain_exactly(0, 1, 2, 3, 4)
    entity_relatives.each_with_index do |i, index|
      expect(i.position).to eq index
    end
  end

  def entity_relatives
    @entity.public_send(relatives(@entity.class))
  end

  def assert_response_related_entity_ids(entity, ids)
    expect(
      parsed_response['data']['relationships'][entity]['data']
      .map { |i| i['id'].to_i }
    ).to eq ids
  end

  def relation_name
    rel[@entity.class]['relatives']
  end

  def shuffle_related_entities(entity)
    new_positions = {}
    entity.public_send(relatives(@entity.class)).each do |rel|
      rel.position = random_position
      new_positions[rel.position] = rel.public_send(relative_id(@entity.class))
      rel.save!
    end
    new_positions.sort.to_h.values
  end

  def create_entity_with_many_relationships(entity, relationship)
    relationship_ids = create_list(relationship, 5).map(&:id)
    entity = create(entity)
    entity.public_send("#{relationship}_ids=", relationship_ids)
    entity.sort_relatives(relationship_ids.map(&:to_s))
    { entity: entity, relationship_ids: relationship_ids }
  end

  def entity_relative_ids
    @entity.public_send(relation_name).pluck(:id)
  end

  def entity_relative_positions
    @entity.public_send(relatives(@entity.class)).pluck(:position)
  end

  def positions
    @positions ||= Array(1..@entity.public_send(relation_name).count)
  end

  def random_position
    positions.delete_at(rand(positions.length))
  end

  def create_related_list(factory)
    create_list(factory, 5)
  end
end
