# frozen_string_literal: true

class ItemSerializer < ActiveModel::Serializer
  has_many :content_teachers, each_serializer: ContentTeacherSerializer

  attributes :name, :slug, :item_type, :free, :active, :code, :downloadable, :tag, :listed,
             :streaming_status, :chat_token, :meta_description, :meta_title, :options,
             :starts_at, :ends_at, :permalink
  attribute :id

  attribute :content_teachers

  def id
    object.token || object.slug
  end

  def content_teachers
    object.content_teachers
  end

  def permalink
    object.permalinks.first&.slug
  end
end
