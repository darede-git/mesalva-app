# frozen_string_literal: true

class LpPage < ActiveRecord::Base
  include SlugHelper

  validates :name, :data, :schema, presence: true
end
