# frozen_string_literal: true

class ItemMedium < ActiveRecord::Base
  include PermalinkValidationHelper

  validates :item_id, uniqueness: { scope: :medium_id }

  belongs_to :item
  belongs_to :medium
end
