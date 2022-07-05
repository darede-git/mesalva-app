# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe ItemMedium, type: :model do
  include PermalinkAssertionHelper

  context 'validations' do
    should_belong_to(:item, :medium)
    it do
      create :item_medium
      is_expected.to validate_uniqueness_of(:item_id).scoped_to(:medium_id)
    end
  end

  context 'on delete' do
    before do
      @education_segment = create(:node)
      @node_module = create(:node_module,
                            node_ids: [@education_segment.id])
      @item = create(:item, node_module_ids: [@node_module.id])
      @medium = create(:medium, item_ids: [@item.id])
      MeSalva::Permalinks::Builder.new(entity_id: @education_segment.id,
                                       entity_class: 'Node')
                                  .build_subtree_permalinks
    end
    context 'deleting entities' do
      it 'removes related permalinks' do
        expect do
          @medium.destroy
        end.to change(Permalink, :count).by(-1)

        expect(Item.find(@item.id)).not_to be_nil
        expect(Item.find(@item.id).permalinks.count).to eq 1

        expect(NodeModule.find(@node_module.id)).not_to be_nil
        expect(NodeModule.find(@node_module.id).permalinks.count).to eq 2

        expect(Node.find(@education_segment.id)).not_to be_nil
        expect(Node.find(@education_segment.id).permalinks.count).to eq 3
      end
    end
    context 'deleting relationships' do
      it 'removes related permalinks' do
        expect do
          @medium.item_media.first.destroy
        end.to change(Permalink, :count).by(-1)
      end
    end
  end
end
