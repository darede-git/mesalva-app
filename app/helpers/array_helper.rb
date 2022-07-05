# frozen_string_literal: true

module ArrayHelper
  def self.to_int_string(ary)
    ary.map(&:to_i).join(',')
  end
end
