# frozen_string_literal: true

class LpBlock < ActiveRecord::Base
  validates :name, :schema, presence: true
end
