# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'permalink builder' do |entities|
  entities.each do |entity|
    it "calls permalink build for entity: #{entity}" do
      new_entity = entity_class(entity)
                   .create!(FactoryBot.attributes_for(entity))

      expect(MeSalva::Permalinks::Builder).to receive(:new)
        .with(entity_id: new_entity.id,
              entity_class: new_entity.class.to_s)
        .and_return(
          MeSalva::Permalinks::Builder.new(entity_id: new_entity.id,
                                           entity_class: new_entity.class.to_s)
        )

      expect_any_instance_of(MeSalva::Permalinks::Builder)
        .to receive(:build_subtree_permalinks)

      subject.perform(new_entity.id, new_entity.class.to_s)
    end
  end
end

def entity_class(entity_sym)
  entity_sym.to_s.classify.constantize
end

RSpec.describe PermalinkBuildWorker do
  describe '#perform' do
    before { Timecop.freeze(Time.now) }
    it_should_behave_like 'permalink builder', %i[node node_module item]

    context 'node with node_modules' do
      it 'creates correct permalinks' do
        node = create(:node)
        node_module = create(:node_module, node_ids: [node.id])
        subject.perform(node.id, 'Node')

        permalink = Permalink.last

        expect(permalink.slug).to eq "#{node.slug}/#{node_module.slug}"
        expect(permalink.node_ids).to eq [node.id]
        expect(permalink.node_module_id).to eq node_module.id

        expect(node_module.permalinks).to eq [permalink]
        expect(node.permalinks).to include permalink
      end
    end
  end
end
