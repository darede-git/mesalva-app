# frozen_string_literal: true

class Permalink::ItemSerializer < BaseItemSerializer
  include ::ActiveRelativesConcern

  has_many :media, serializer: Permalink::MediumSerializer

  attribute :medium, if: :include_medium?
  attributes :entity_type, :status_code
end
