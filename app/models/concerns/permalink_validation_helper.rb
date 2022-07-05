# frozen_string_literal: true

module PermalinkValidationHelper
  extend ActiveSupport::Concern
  include EntityTypeHelper

  included do
    validate :validate_permalink_tree, if: :must_validate?
    before_save :remove_ancestry_permalinks, if: :node?
  end

  def validate_permalink_tree
    validator = MeSalva::Permalinks::Validator.new(self)

    return if validator.valid?

    errors.add(permalink_class, I18n.t('permalink.duplicated_permalink'))
    validator.duplicated_permalinks.each do |permalink|
      errors.add(:permalink, permalink)
    end
  end

  def rebuild_permalink
    MeSalva::Permalinks::BrokenPermalinkFixer.new(self).rebuild
    Rails.cache.clear
  end

  def permalink_builder
    MeSalva::Permalinks::Builder.new(entity_id: id, entity_class: self.class.to_s)
  end

  def permalink_class
    return :medium if item_medium?

    return :item if node_module_item?

    return :node_module if node_node_module?

    :node if node?
  end

  def must_validate?
    (item_medium? || node_module_item? || node? || node_node_module?)
  end

  def remove_ancestry_permalinks
    return unless previous_ancestry_permalinks?

    parent = Node.find(ancestry_was.split('/').last)
    parent.permalinks
          .ending_with_or_equal_slug("#{parent.slug}/#{slug}").destroy_all
  end

  def previous_ancestry_permalinks?
    ancestry_changed? && ancestry_was.present?
  end

  def remove_node_node_module_permalinks(removed_obj)
    ordered_object_permalinks(removed_obj).each do |permalink|
      if node_module?(removed_obj)
        next unless common_node_ids(permalink, removed_obj).empty?

        permalink.destroy
      elsif node?(removed_obj)
        next if nil_permalink_node_module?(permalink)

        next if obj_node_module_includes?(removed_obj, permalink.node_module_id)

        permalink.destroy
      end
    end
  end

  def ordered_object_permalinks(obj)
    obj.permalinks.order(:id)
  end

  def nil_permalink_node_module?(permalink)
    permalink.node_module_id.nil?
  end

  def common_node_ids(obj1, obj2)
    obj1.node_ids & obj2.node_ids
  end

  def obj_node_module_includes?(obj, node_module_id)
    obj.node_node_modules.map(&:node_module_id).include? node_module_id
  end
end
