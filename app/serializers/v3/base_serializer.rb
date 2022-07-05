# frozen_string_literal: true

class V3::BaseSerializer < ActiveModel::Serializer
  def serialized_json
    {
      results: array? ? serialize_many : serialize_one
    }.to_json
  end

  def array?
    %w[ActiveRecord::Relation Array].include?(@object.class.name)
  end

  def serialize_many
    @object.map { |row| serialize_one(row) }
  end

  def serialize_one(object = @object)
    result = {}
    attributes.each do |key, _value|
      result[key] = read_attribute_value(key, object)
    end
    result
  end

  def read_attribute_value(key, object)
    return self.send(key, object) if respond_to?(key) && key != :image

    object.send(key)
  end

  def read_attribute_for_serialization(arg)
    arg
  end

  def respond_key(key, object)
    return nil unless object.respond_to?(key)

    object.send(key)
  end
end
