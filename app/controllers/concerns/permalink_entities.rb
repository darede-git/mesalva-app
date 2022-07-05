# frozen_string_literal: true

module PermalinkEntities
  extend ActiveSupport::Concern

  private

  def permalink_ends_with_medium?
    return true if @permalink.medium_id.present?
  end

  def merge_last_medium_into_item
    @entities[-2] = Permalink::ItemSerializer.new(
      @permalink.item,
      include_status_and_medium_if_allowed
    ).as_json

    @entities.pop
  end

  def include_status_and_medium_if_allowed
    {
      medium_id: @permalink.medium_id,
      accessible_permalink: accessible_permalink?,
      user_present: user_present?
    }
  end

  def serialize_last_entity
    @entities[-1] = entity_serializable_hash(
      @entities.last,
      accessible_permalink: accessible_permalink?,
      user_present: user_present?
    )
  end

  def user_present?
    authorized_role?(%w[admin user teacher])
  end

  def serialize_entities
    return if @permalink.entities.empty?
    return merge_last_medium_into_item if permalink_ends_with_medium?

    serialize_last_entity
  end
end
