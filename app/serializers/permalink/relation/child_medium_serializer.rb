# frozen_string_literal: true

class Permalink::Relation::ChildMediumSerializer < ActiveModel::Serializer
  has_many :answers, serializer: Permalink::Relation::MediumAnswerSerializer
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
             :video_id,
             :options

  def attachment
    object.attachment.serializable_hash
  end
end
