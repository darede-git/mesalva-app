# frozen_string_literal: true

class PagarmeTransaction < ActiveRecord::Base
  belongs_to :order_payment

  validates  :transaction_id, presence: true, allow_blank: false
  validates_uniqueness_of :transaction_id
end
