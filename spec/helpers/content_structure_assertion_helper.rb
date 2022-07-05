# frozen_string_literal: true

module ContentStructureAssertionHelper
  def assert_response_does_not_have_included_relationships
    expect(parsed_response.keys).not_to include('included')
  end

  def assert_presence_of_relationships(object, relationships)
    expect(object['relationships'].keys).to eq(relationships)
  end

  def assert_presence_of_relationships_in_each_object(relationships)
    parsed_response['data'].each do |object|
      assert_presence_of_relationships(object, relationships)
    end
  end

  def assert_content_update(model, member, serializer)
    model.reload
    expect(model.name).to eq new_attributes[:name]
    assert_updated_by(model, member)
    assert_jsonapi_response(:ok, model, serializer)
  end

  def asserts_create_action(attributes)
    assert_medium_and_answer_persistence(attributes)
    medium = Medium.last
    expect(medium.created_by).to eq(admin.uid)
    asserts_jsonapi_and_relationships(:created, medium)
  end

  def assert_medium_and_answer_persistence(attributes)
    expect do
      post :create, params: attributes
    end.to change(Medium, :count).by(1)
                                 .and change(Answer, :count).by(5)
  end

  def asserts_create_action_invalid(fixture, trait = nil)
    factory_attr = attributes_for(fixture, trait)
    post :create, params: factory_attr

    assert_type_and_status(:unprocessable_entity)
  end

  def asserts_jsonapi_and_relationships(status, model)
    assert_jsonapi_response(status, model, EntityMediumSerializer, [:answers])
    assert_presence_of_relationships(parsed_response['data'],
                                     %w[nodes items
                                        node-modules answers])
  end

  def attributes_for(fixture, trait = nil)
    FactoryBot.attributes_for(fixture, trait)
  end

  def assert_updated_by(model, member)
    expect(model.updated_by).to eq(member.uid)
  end

  def assert_created_by(model, member)
    expect(model.created_by).to eq(member.uid)
  end
end
