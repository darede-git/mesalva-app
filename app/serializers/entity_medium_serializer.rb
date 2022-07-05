# frozen_string_literal: true

class EntityMediumSerializer < ActiveModel::Serializer
  has_many :nodes
  has_many :items, serializer: EntityItemSerializer
  has_many :node_modules
  has_many :answers, serializer: EntityAnswerSerializer

  attributes :id,
             :name,
             :description,
             :attachment,
             :seconds_duration,
             :provider,
             :correction,
             :code,
             :active,
             :matter,
             :subject,
             :difficulty,
             :concourse,
             :created_by,
             :updated_by,
             :medium_type,
             :medium_text,
             :video_id,
             :tag,
             :token,
             :listed

  def attachment
    return object.attachment.serializable_hash unless object.medium_type == 'book'
    object.attachment.url.gsub('.zip', '/index.html')
  end
end
