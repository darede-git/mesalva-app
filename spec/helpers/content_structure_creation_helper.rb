# frozen_string_literal: true

module ContentStructureCreationHelper
  def node_to_medium_structure
    node = create(:node)
    node_module = create(:node_module, nodes: [node])
    item = create(:item, node_modules: [node_module])
    medium = create(:medium,
                    items: [item], medium_type: 'video',
                    seconds_duration: 15)
    { node: node, node_module: node_module, item: item, medium: medium }
  end

  def add_media_to_item(item_id, quantity, medium_type = 'video')
    create_list("medium_#{medium_type}".to_sym,
                quantity, item_ids: [item_id])
  end

  def add_node_module_with_media_to_node(
    node, media_quantity, medium_type = 'video'
  )
    node_module = create(:node_module, nodes: [node])
    item = create(:item, node_modules: [node_module])
    add_media_to_item(item.id, media_quantity, medium_type)
  end

  def fill_node_module_tree(node_module, top_node)
    node = create(:node_subject, parent_id: top_node.id)
    node_module.node_ids = [node_module.node_ids << node.id].flatten
    item = create(:item, node_modules: [node_module])
    create(:medium, items: [item])
    MeSalva::Permalinks::Builder.new(entity_id: node.id, entity_class: 'Node')
                                .build_subtree_permalinks
    node
  end

  def node_to_many_node_modules
    node = create(:node)
    child_node = create(:node_area, parent_id: node.id)
    node_modules = FactoryBot
                   .create_list(:node_module, 5, nodes: [child_node])
    MeSalva::Permalinks::Builder.new(entity_id: node.id, entity_class: 'Node')
                                .build_subtree_permalinks
    { node: node, child_node: child_node, node_modules: node_modules }
  end

  def exercise_with_long_text(str_size)
    FactoryBot.build(:medium_exercise,
                     medium_text: string_with_size_bigger_than(str_size))
  end

  def create_platform_node
    node = FactoryBot.build(:node, node_type: 'platform', id: 1)
    node.save(validate: false)
  end

  def string_with_size_bigger_than(str_size)
    str = String.new
    str.concat('ábcdê') until str.length > str_size
    str
  end
end
