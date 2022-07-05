# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/permalinks/validator'

describe MeSalva::Permalinks::Validator do
  include PermalinkAssertionHelper
  include PermalinkBuildingHelper

  describe 'validating entity permalinks creation' do
    context 'adding medium to item' do
      before do
        @item = create(:item)
        @entities = parents_for(@item)
        build_permalinks(@entities[:education_segment], :subtree)
      end
      context 'equal permalink already exists' do
        before do
          @medium = create(:medium)
          last_permalink = Permalink.order(:id).last
          @permalink = FactoryBot
                       .create(:permalink,
                               slug: "#{last_permalink.slug}/#{@medium.slug}")
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          item_medium_count = ItemMedium.count
          expect do
            @medium.item_ids = [@item.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Medium permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(ItemMedium.count).to eq item_medium_count
        end
      end
    end
    context 'adding item to node_module' do
      before do
        @node_module = create(:node_module)
        @entities = parents_for(@node_module)
        build_permalinks(@entities[:education_segment], :subtree)
      end
      context 'equal permalink already exists' do
        before do
          @item = create(:item)
          last_permalink = Permalink.order(:id).last
          @permalink = FactoryBot
                       .create(:permalink,
                               slug: "#{last_permalink.slug}/#{@item.slug}")
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          node_module_item_count = NodeModuleItem.count
          expect do
            @item.node_module_ids = [@node_module.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Item permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeModuleItem.count).to eq node_module_item_count
        end
      end
      context 'item_medium permalink already exists' do
        before do
          @item = create(:item)
          @medium = create(:medium, item_ids: [@item.id])
          last_permalink = Permalink.order(:id).last
          slug = "#{last_permalink.slug}/#{@item.slug}/#{@medium.slug}"
          @permalink = create(:permalink, slug: slug)
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          node_module_item_count = NodeModuleItem.count
          expect do
            @item.node_module_ids = [@node_module.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Item permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeModuleItem.count).to eq node_module_item_count
        end
      end
    end
    context 'adding node_module to node' do
      before do
        @node = create(:node)
        @area = create(:node_area, parent: @node)
        build_permalinks(@node, :subtree)
        @node_module = create(:node_module)
      end
      context 'equal permalink already exists' do
        before do
          last_permalink = Permalink.order(:id).last
          permalink = "#{last_permalink.slug}/#{@node_module.slug}"
          @permalink = create(:permalink, slug: permalink)
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          node_node_module_count = NodeNodeModule.count
          expect do
            @area.node_module_ids = [@node_module.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node module permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeNodeModule.count).to eq node_node_module_count
        end
      end
      context 'node_module_item permalink already exists' do
        before do
          @item = create(:item, node_module_ids: [@node_module.id])
          last_permalink = Permalink.order(:id).last
          slug = "#{last_permalink.slug}/#{@node_module.slug}/#{@item.slug}"
          @permalink = create(:permalink, slug: slug)
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          node_node_module_count = NodeNodeModule.count
          expect do
            @area.node_module_ids = [@node_module.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node module permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeNodeModule.count).to eq node_node_module_count
        end
      end
      context 'item_medium permalink already exists' do
        before do
          @item = create(:item, node_module_ids: [@node_module.id])
          @medium = create(:medium, item_ids: [@item.id])
          last_permalink = Permalink.order(:id).last
          slug = "#{last_permalink.slug}/#{@node_module.slug}/"\
                 "#{@item.slug}/#{@medium.slug}"
          @permalink = create(:permalink, slug: slug)
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          node_node_module_count = NodeNodeModule.count
          expect do
            @area.node_module_ids = [@node_module.id]
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node module permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeNodeModule.count).to eq node_node_module_count
        end
      end
    end
    context 'adding node to node' do
      before do
        @node = create(:node)
        @area = create(:node_area)
        build_permalinks(@node, :subtree)
        @last_permalink = Permalink.order(:id).last
      end
      context 'education segment has other nodes' do
        it 'does not iterate over unneeded permalinks' do
          @area.parent_id = @node.id
          @area.save
          build_permalinks(@node, :subtree)

          area2 = create(:node_area)
          area2.parent_id = @node.id

          expect_any_instance_of(MeSalva::Permalinks::Validator)
            .not_to receive(:validate_node_children)
            .with("#{@node.slug}/#{@area.slug}/#{area2.slug}")

          area2.validate
        end
      end
      context 'equal permalink already exists' do
        before do
          @permalink = FactoryBot
                       .create(:permalink,
                               slug: "#{@last_permalink.slug}/#{@area.slug}")
        end
        it 'returns RecordInvalid exception' do
          permalink_count = Permalink.count
          expect do
            @area.parent_id = @node.id
            @area.save!
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node permalink já existente, '\
            "Permalink #{@permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
        end
      end
      context 'node_node_module permalink already exists' do
        before do
          @node_module = create(:node_module)
          @area.node_module_ids = [@node_module.id]
        end
        it 'returns RecordInvalid exception' do
          slug = "#{@last_permalink.slug}/#{@area.slug}/#{@node_module.slug}"
          permalink = create(:permalink, slug: slug)
          permalink_count = Permalink.count
          node_node_module_count = NodeNodeModule.count
          expect do
            @area.parent_id = @node.id
            @area.save!
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node permalink já existente, '\
            "Permalink #{permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
          expect(NodeNodeModule.count).to eq node_node_module_count
        end
      end
      context 'equal permalink already exists in a deeper node level' do
        before do
          @subject = create(:node_subject, parent_id: @area.id)
          @year = create(:node_year, parent_id: @subject.id)
        end
        it 'returns RecordInvalid exception' do
          slug = "#{@last_permalink.slug}/#{@area.slug}/#{@subject.slug}"\
                 "/#{@year.slug}"
          permalink = create(:permalink, slug: slug)
          permalink_count = Permalink.count
          expect do
            @area.parent_id = @node.id
            @area.save!
          end.to raise_error(
            ActiveRecord::RecordInvalid,
            'A validação falhou: Node permalink já existente, '\
            "Permalink #{permalink.slug}"
          )
          expect(Permalink.count).to eq permalink_count
        end
        context 'node_node_module permalink already exists' do
          before do
            @node_module = create(:node_module)
            @year.node_module_ids = [@node_module.id]
          end
          it 'returns RecordInvalid exception' do
            slug = "#{@last_permalink.slug}/#{@area.slug}/#{@subject.slug}"\
              "/#{@year.slug}/#{@node_module.slug}"
            permalink = create(:permalink, slug: slug)
            permalink_count = Permalink.count
            node_node_module_count = NodeNodeModule.count
            expect do
              @area.parent_id = @node.id
              @area.save!
            end.to raise_error(
              ActiveRecord::RecordInvalid,
              'A validação falhou: Node permalink já existente, '\
              "Permalink #{permalink.slug}"
            )
            expect(Permalink.count).to eq permalink_count
            expect(NodeNodeModule.count).to eq node_node_module_count
          end
          context 'node_module_item permalink already exists' do
            before do
              @item = create(:item,
                             node_module_ids: [@node_module.id])
            end
            it 'returns RecordInvalid exception' do
              slug = "#{@last_permalink.slug}/#{@area.slug}/#{@subject.slug}"\
                "/#{@year.slug}/#{@node_module.slug}/#{@item.slug}"
              permalink = create(:permalink, slug: slug)

              permalink_count = Permalink.count
              node_node_module_count = NodeNodeModule.count
              expect do
                @area.parent_id = @node.id
                @area.save!
              end.to raise_error(
                ActiveRecord::RecordInvalid,
                'A validação falhou: Node permalink já existente, '\
                "Permalink #{permalink.slug}"
              )
              expect(Permalink.count).to eq permalink_count
              expect(NodeNodeModule.count).to eq node_node_module_count
            end
            context 'item_medium permalink already exists' do
              before do
                @medium = create(:medium, item_ids: [@item.id])
              end
              it 'returns RecordInvalid exception' do
                slug = "#{@last_permalink.slug}/#{@area.slug}/#{@subject.slug}"\
                       "/#{@year.slug}/#{@node_module.slug}/#{@item.slug}"\
                       "/#{@medium.slug}"
                permalink = create(:permalink, slug: slug)

                permalink_count = Permalink.count
                node_node_module_count = NodeNodeModule.count

                expect do
                  @area.parent_id = @node.id
                  @area.save!
                end.to raise_error(
                  ActiveRecord::RecordInvalid,
                  'A validação falhou: Node permalink já existente, '\
                  "Permalink #{permalink.slug}"
                )
                expect(Permalink.count).to eq permalink_count
                expect(NodeNodeModule.count).to eq node_node_module_count
              end
            end
          end
        end
      end
    end
  end
end
