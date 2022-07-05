# frozen_string_literal: true

class NetPromoterScore < ActiveRecord::Base
  belongs_to :promotable, polymorphic: true
end
