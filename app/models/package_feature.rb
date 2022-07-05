# frozen_string_literal: true

class PackageFeature < ActiveRecord::Base
  validates :package_id, uniqueness: { scope: :feature_id }

  belongs_to :package
  belongs_to :feature
end
