# frozen_string_literal: true

class Content::Relation::ChildMediumSerializer < ActiveModel::Serializer
  has_many :answers, serializer: Content::Relation::MediumAnswerSerializer

  attributes :name,
             :description,
             :attachment,
             :provider,
             :correction,
             :code,
             :active,
             :matter,
             :subject,
             :difficulty,
             :concourse,
             :slug,
             :medium_type,
             :medium_text,
             :video_id

  def attachment
    object.attachment.serializable_hash
  end
end
