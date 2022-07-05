# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/builder'

RSpec.describe Node, type: :model do
  include SerializationHelper
  include SlugAssertionHelper
  include RelationshipOrderAssertionHelper
  include ContentStructureCreationHelper

  it_should_behave_like 'a searchable entity', Node
  it_should_behave_like 'an entity with meta tags', Node

  context 'validations' do
    should_be_present(:name, :slug)
    should_have_many(:permalinks)
    it do
      should validate_inclusion_of(:node_type).in_array(%w[
                                                          area
                                                          course
                                                          cycle
                                                          department
                                                          education_segment
                                                          study_plan
                                                          subject
                                                          year
                                                          concourse
                                                          prep_test
                                                          lecture
                                                          essay
                                                          live
                                                          test_repository_group
                                                          test_repository
                                                          chapter
                                                          chapter_type
                                                          library
                                                          area_subject
                                                          emotional_support
                                                          lecture_class
                                                          public_document
                                                        ])
    end

    it do
      should_not allow_value('platform').for(:node_type)
      should_not allow_value('node_module').for(:node_type)
      should_not allow_value('module').for(:node_type)
    end

    context 'node type is subject' do
      subject { FactoryBot.build(:node_subject) }
      should_be_present(:color_hex)
    end

    context 'node type is area' do
      subject { FactoryBot.build(:node_area) }
      should_be_present(:color_hex)
    end

    context 'node type is not area or subject' do
      %w[cycle course department education_segment study_plan year essay live
         test_repository_group test_repository chapter chapter_type library
         public_document].each do |type|
        subject { FactoryBot.build(:node, node_type: type) }
        it { should_not validate_presence_of :color_hex }
      end
    end
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active nodes' do
        assert_valid('node')
      end
    end
  end

  context 'on save' do
    it 'creates a slug' do
      create_and_assert_slug('node', 'name')
    end
    it 'sets position if not provided' do
      node = create(:node_nil_position)
      child_node = create(:node_nil_position,
                          parent_id: node.id,
                          name: 'child')
      second_child_node = create(:node_nil_position,
                                 parent_id: node.id,
                                 name: 'second_child')
      expect(node.position).to eq 1
      expect(child_node.position).to eq 1
      expect(second_child_node.position).to eq 2
    end
    it 'does not set position if provided' do
      node = create(:node, position: 5)
      child_node = create(:node, position: 3)
      second_child_node = create(:node, position: 9)
      expect(node.position).to eq 5
      expect(child_node.position).to eq 3
      expect(second_child_node.position).to eq 9
    end
  end

  context 'node has many child nodes' do
    before do
      @node = create(:node, position: 1)
      create(:node_area, parent_id: @node.id, position: 5)
      create(:node_area, parent_id: @node.id, position: 2)
      create(:node_area, parent_id: @node.id, position: 1)
      create(:node_area, parent_id: @node.id, position: 4)
      create(:node_area, parent_id: @node.id, position: 3)
    end
    it 'orders children by position' do
      expect(@node.children.pluck(:position)).to eq [1, 2, 3, 4, 5]
      expect(@node.subtree.pluck(:position)).to eq [1, 1, 2, 3, 4, 5]
    end
    context 'permalink exists' do
      before do
        MeSalva::Permalinks::Builder.new(entity_id: @node.id,
                                         entity_class: 'Node')
                                    .build_subtree_permalinks
      end
      context 'removing parent from child node' do
        it 'removes related permalinks' do
          @child_node = @node.children.first
          expect do
            @child_node.parent = nil
            @child_node.save
          end.to change(Permalink, :count).by(-1)
          expect(@child_node.permalinks).to be_empty
        end
      end
      context 'child node has children' do
        before do
          @node.children.each do |node|
            create(:node_subject, parent_id: node.id)
            MeSalva::Permalinks::Builder.new(entity_id: node.id,
                                             entity_class: 'Node')
                                        .build_subtree_permalinks
          end
        end
        it 'removes related and following permalinks' do
          @child_node = @node.children.first
          @grand_child_node = @child_node.children.first
          expect(@child_node.permalinks.count).to eq 2
          expect do
            @child_node.parent = nil
            @child_node.save
          end.to change(Permalink, :count).by(-2)
          expect(@child_node.permalinks).to be_empty
          expect(@grand_child_node.permalinks).to be_empty
        end
      end
    end
  end
  context 'node has no parent' do
    context 'when adding parent' do
      it 'does not try to remove related permalinks' do
        @parent_node = create(:node)
        @child_node = create(:node_area)
        expect do
          @child_node.parent = @parent_node
          @child_node.save
        end.to change(Permalink, :count).by(0)
        expect(@child_node.permalinks).to be_empty
      end
    end
  end
  context 'node has many node_modules' do
    it 'orders node_modules by position' do
      assert_relationship_id_ordering(:node, :node_module)
    end
    context 'permalinks exists' do
      before do
        @entities = node_to_many_node_modules
      end
      context 'removing node_module from node' do
        it 'removes related node_module permalinks' do
          expect do
            @entities[:child_node]
              .node_module_ids = @entities[:node_modules][0..3].map(&:id)
          end.to change(Permalink, :count).by(-1)
          expect(@entities[:node_modules].last.permalinks).to be_empty
          expect(@entities[:child_node].permalinks).not_to be_empty
        end
        context 'node_module has many parents' do
          before do
            @node2 = fill_node_module_tree(@entities[:node_modules].last,
                                           @entities[:node])
          end
          it 'removes only permalinks related with removed node' do
            expect do
              @entities[:child_node]
                .node_module_ids = @entities[:node_modules][0..3].map(&:id)
            end.to change(Permalink, :count).by(-3)
            expect(@entities[:node_modules].last.permalinks.count).to eq 3

            expect(@entities[:node_modules].last.permalinks.order(:id).last)
              .to eq @node2.permalinks.order(:id).last

            @entities[:node_modules].last.permalinks.each do |permalink|
              expect(@entities[:child_node].permalinks.pluck(:slug))
                .not_to include permalink.slug
            end
          end
        end
      end
    end
  end
  context 'getting education segments' do
    before :each do
      Node.destroy_all
      create_platform_node
    end
    context 'get more than one education_segment' do
      before do
        node_pos3 = create(:node, id: 4, parent_id: 1, position: 3)
        node_pos2 = create(:node, id: 5, parent_id: 1, position: 2)
        node_pos1 = create(:node, id: 2, parent_id: 1, position: 1)
        @children_by_pos = [
          node_pos1,
          node_pos2,
          node_pos3
        ]
      end
      it 'returns the segments ordered by position' do
        ed_segments_ids_and_pos = Node.education_segments.pluck(:id, :position)
        children_ids_and_pos = @children_by_pos.map { |s| [s.id, s.position] }

        expect(ed_segments_ids_and_pos).to eq(children_ids_and_pos)
      end
      context 'platform node has child types != education_segment' do
        before do
          create(:node, id: 6, parent_id: 1, node_type: 'live')
          create(:node, id: 7, parent_id: 1,
                        node_type: 'public_document')
        end

        it 'does not return nodes with node_type != education_segment' do
          expect(Node.education_segments.pluck(:id)).not_to include(6, 7)
        end
      end
    end

    context 'get one education_segment by slug' do
      before do
        @education_segment = create(:node, id: 2, parent_id: 1)
        @area = create(:node_area, id: 3, parent_id:
            @education_segment.id)
      end

      context 'slug belongs to an education_segment' do
        it 'returns an education segment' do
          node = Node.education_segment_by_slug(@education_segment.slug)
          expect(node).to eq(@education_segment)
        end
      end

      context 'slug does not belong to an education_segment' do
        it 'returns nil' do
          node = Node.education_segment_by_slug(@area.slug)
          expect(node).to be_nil
        end
      end
    end
  end
end
