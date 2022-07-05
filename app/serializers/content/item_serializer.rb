# frozen_string_literal: true

class Content::ItemSerializer < BaseItemSerializer
  include ::ActiveRelativesConcern

  has_many :media, serializer: Content::MediumSerializer

  has_many :content_teachers, serializer: ContentTeacherSerializer

  attribute :medium, if: :include_medium?
  attributes :entity_type, :chat_token, :meta_title, :meta_description, :options
end
