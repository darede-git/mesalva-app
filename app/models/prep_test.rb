# frozen_string_literal: true

class PrepTest < ActiveRecord::Base
  has_many :prep_test_scores

  validates_presence_of :permalink_slug
  validates_uniqueness_of :permalink_slug
end
