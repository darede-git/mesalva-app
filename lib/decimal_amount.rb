# frozen_string_literal: true

require "bigdecimal"

class DecimalAmount
  class NotNumber < StandardError; end

  def initialize(amount)
    raise NotNumber unless amount.is_a?(Numeric)

    @amount = amount
  end

  def to_i
    @amount
      .to_s
      .gsub(/(\.[0-9])\Z/, '\10')
      .gsub(/[^0-9]/, '')
      .to_i
  end
end
