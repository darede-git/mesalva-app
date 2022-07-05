# frozen_string_literal: true

class CancellationQuizSerializer < ActiveModel::Serializer
  has_one :net_promoter_score
  attributes :id, :user_uid, :order_id, :quiz

  def user_uid
    object.user.uid
  end

  def order_id
    object.order.token
  end
end
