# frozen_string_literal: true

class Permalink::Relation::ChildMediumAnswerSerializer < ActiveModel::Serializer
  has_many :answers,
           serializer: Permalink::Relation::MediumAnswerSerializer,
           options: { client: "APP_ENEM" }
  attributes :name,
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
             :slug,
             :medium_type,
             :medium_text,
             :video_id

  def attachment
    object.attachment.serializable_hash
  end
end
