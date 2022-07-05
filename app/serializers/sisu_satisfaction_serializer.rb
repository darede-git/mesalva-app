# frozen_string_literal: true

class SisuSatisfactionSerializer < ActiveModel::Serializer
  attributes :satisfaction, :plan

  belongs_to :user
end
