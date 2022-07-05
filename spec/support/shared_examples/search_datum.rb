# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a searchable entity' do |entity_class|
  context 'as a searchable entity' do
    let!(:entity) do
      create(entity_class.name.underscore.downcase.to_sym)
    end
    let!(:search_data) do
      entity_class_name = entity_class.name.underscore.downcase
      entity_id = "#{entity_class_name}_id"
      create(:search_datum, entity_id => entity.id)
    end
    context 'on update' do
      it 'updates search data that ends with entity' do
        entity.update(name: 'some name')
        search_data.reload

        expect(search_data.name).to eq('some name')
      end
    end
    context 'on destroy' do
      it 'destroys search data related to entity' do
        expect { entity.destroy }.to change(SearchDatum, :count).by(-1)
      end
    end
  end
end
