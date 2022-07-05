# frozen_string_literal: true

class CancellationQuiz < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  has_one :net_promoter_score, as: :promotable
  accepts_nested_attributes_for :net_promoter_score

  validates :order_id, :user_id, :quiz, presence: true, allow_blank: false
end
