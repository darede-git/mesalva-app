# frozen_string_literal: true

module RemovableEntityRelativesConcern
  extend ActiveSupport::Concern
  included do
    before_action :allow_removable_entity_relatives_params, only: [:update]
  end

  def allow_removable_entity_relatives_params
    related_entities.each do |rel|
      params[rel] = [] if params.key?(rel) && params[rel].nil?
    end
  end

  def related_entities
    %w[node_ids node_module_ids item_ids medium_ids]
  end
end
