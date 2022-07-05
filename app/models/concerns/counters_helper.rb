# frozen_string_literal: true

module CountersHelper
  extend ActiveSupport::Concern

  def medium_count
    Hash[Medium::ALLOWED_TYPES.map { |type| [type, 0] }]
      .merge(active_medium_count_by_medium_type)
  end

  def medium_count_from_query
    entity_counters = medium_count_rows_hash
    counters = {}
    Medium::ALLOWED_TYPES.each do |medium_type|
      counters[medium_type] = entity_counters[medium_type].to_i
    end
    counters
  end

  def dasherized_medium_count
    Hash[Medium::ALLOWED_TYPES.map { |type| [type.dasherize, 0] }]
  end

  def medium_count_rows_hash
    medium_count_query.rows.to_h
  end

  def medium_count_query
    ActiveRecord::Base.connection.select_all "
    SELECT
      medium_type,
      medium_count
    FROM
      vw_node_medium_count
    WHERE
      node_id = #{id.to_s.to_i}"
  end

  def related_active_items
    items.unscoped.active.where(id: item_ids)
  end

  def related_active_media
    media.unscoped.active.where(id: medium_ids)
  end
end
