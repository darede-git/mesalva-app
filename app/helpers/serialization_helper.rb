# frozen_string_literal: true

require 'me_salva/permalinks/content'

module SerializationHelper
  extend ActiveSupport::Concern

  def serialize_legacy(entity, **attrs)
    "#{serializer_legacy_name(entity, attrs)}Serializer"
      .constantize
      .new(entity, include: attrs[:include], meta: attrs[:meta], params: attrs[:params])
      .serialized_json
  end

  def serialize(entity, **attrs)
    serializer_name(entity, attrs[:serializer], attrs[:v] || 2)
      .constantize
      .new(entity, include: attrs[:include], meta: attrs[:meta], params: attrs[:params])
      .serialized_json
  end

  def entity_serializable_hash(namespace = 'Permalink', obj, **options)
    ::MeSalva::Permalinks::Content.new('', namespace)
                                  .serializable_hash_for(obj, options)
  end

  def image
    object.image.serializable_hash
  end

  private

  def serializer_legacy_name(entity, attrs)
    return entity.class.to_s.gsub(/[:(].*/, '') if attrs[:default_serializer]

    attrs[:class] || entity.class
  end

  def serializer_name(entity, serializer, version)
    return "#{serializer}Serializer" if serializer.present? && version == 1
    return "V#{version}::#{serializer}Serializer" if serializer.present?

    "V#{version}::#{entity.class.to_s.gsub(/[:(].*/, '')}Serializer"
  end

  def entity_type
    entity.class.to_s.underscore
  end

  def entity
    return find_entity_for(@obj) if @obj.is_a?(Hash)

    @obj
  end

  def find_entity_for(hash)
    hash[:entity_type].camelize.constantize.find(hash[:id])
  end

  def serializable_class
    return "#{entity.node_type.camelize}Node".camelize if entity.instance_of?(Node)

    entity.class
  end
end
