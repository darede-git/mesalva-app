# frozen_string_literal: true

class NetPromoterScoreSerializer < ActiveModel::Serializer
  attributes :id, :score, :reason
end
