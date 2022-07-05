# frozen_string_literal: true

module EntityTypeHelper
  def node?(entity = self)
    entity.instance_of?(Node)
  end

  def node_module?(entity = self)
    entity.instance_of?(NodeModule)
  end

  def item?(entity = self)
    entity.instance_of?(Item)
  end

  def medium?(entity = self)
    entity.instance_of?(Medium)
  end

  def item_medium?(entity = self)
    entity.instance_of?(ItemMedium)
  end

  def node_module_item?(entity = self)
    entity.instance_of?(NodeModuleItem)
  end

  def node_node_module?(entity = self)
    entity.instance_of?(NodeNodeModule)
  end
end
