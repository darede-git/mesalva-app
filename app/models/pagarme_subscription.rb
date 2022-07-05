# frozen_string_literal: true

class PagarmeSubscription < ActiveRecord::Base
  belongs_to :subscription

  validates  :pagarme_id, presence: true, allow_blank: false
  validates_uniqueness_of :pagarme_id
end
