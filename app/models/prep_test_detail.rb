# frozen_string_literal: true

class PrepTestDetail < ActiveRecord::Base
  validates :token, :weight, :suggestion_type, presence: true
  
  scope :prep_test_detail_where_token, lambda { |token |
      where(token: token)
  }
end
