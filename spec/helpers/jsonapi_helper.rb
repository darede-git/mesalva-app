# frozen_string_literal: true

module JsonAPIHelper
  def to_jsonapi(object, serializer = Object, includes = nil)
    @obj = object
    return json_from(serializer, includes) if is_ams?(serializer)

    return serializer.new(@obj).serialized_json if serializer?(serializer)

    object_serializer.new(@obj).serialized_json
  end

  def is_ams?(serializer)
    superclasses = [serializer.superclass,
                    object_serializer.superclass,
                    object_serializer.superclass.superclass]
    superclasses.any? { |s| s == ActiveModel::Serializer }
  end

  def json_from(serializer, includes)
    ActiveModelSerializers::Adapter
      .create(serializer(serializer), adapter: :json_api, include: includes)
      .to_json
  end

  def parsed_response
    JSON.parse(response.body)
  end

  private

  def serializer(serializer)
    if array?
      return ActiveModel::Serializer::CollectionSerializer.new(
        @obj,
        serializer: serializer
      )
    end

    return serializer.new(@obj) if serializer?(serializer)

    object_serializer.new(@obj)
  end

  def object_serializer
    instance = @obj unless array?
    instance ||= @obj.first
    return "Entity#{instance.class}Serializer".constantize if entity?(instance)

    "#{instance.class}Serializer".constantize
  rescue NameError
    Object
  end

  def entity?(instance)
    [Node, Item].any? { |e| e == instance.class }
  end

  def array?
    @obj.is_a?(Array)
  end

  def serializer?(serializer)
    serializer.superclass != BasicObject
  end
end
