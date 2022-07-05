# frozen_string_literal: true

class TriReference < ActiveRecord::Base
  belongs_to :item

  validates_presence_of :year, presence: true
  validates_presence_of :exam, presence: true
  validates :exam, inclusion: { in: %w[humanas linguagens natureza matematica] }
  validates :language, presence: {
    if: -> { exam == "linguagens" && language_valid? }
  }

  def language_valid?
    return true if language == "ing" || language == "esp"

    errors.add(:language, 'should be "ing" or "esp"')
  end
end
