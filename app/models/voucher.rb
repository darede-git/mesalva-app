# frozen_string_literal: true

class Voucher < ActiveRecord::Base
  include TokenHelper
  before_validation -> { generate_token(converters: converters) }, on: :create

  belongs_to :order
  belongs_to :access
  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :order, :user, presence: true

  def converters
    lambda do |x|
      x.prepend('fa').upcase![0..9]
    end
  end
end
