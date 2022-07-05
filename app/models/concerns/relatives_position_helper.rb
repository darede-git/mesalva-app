# frozen_string_literal: true

module RelativesPositionHelper
  extend ActiveSupport::Concern

  def sort_relatives(ordered_ids)
    return if ordered_ids.nil? || ordered_ids.empty?

    ordered_ids = ordered_ids.map(&:to_s)
    public_send(relatives).each do |rel|
      rel.update(position: ordered_ids.index(rel.public_send(relative_id).to_s))
    end
  end

  private

  def relatives(entity_class = self.class)
    "#{entity_class.to_s.underscore}_#{rel[entity_class]['relatives']}"
  end

  def relative_id(entity_class = self.class)
    rel[entity_class]['relative_id']
  end

  def rel
    {
      Node => { 'relatives' => 'node_modules',
                'relative_id' => 'node_module_id' },
      NodeModule => { 'relatives' => 'items',
                      'relative_id' => 'item_id' },
      Item => { 'relatives' => 'media',
                'relative_id' => 'medium_id' }
    }
  end
end
