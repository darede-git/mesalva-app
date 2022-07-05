# frozen_string_literal: true

class Permalink::Relation::MediumAnswerSerializer < ActiveModel::Serializer
  attributes :id, :text
  attribute :correct, if: :include_correct?

  def include_correct?
    @instance_options.try(:[], :options).try(:[], :client) == "APP_ENEM"
  end
end
