# frozen_string_literal: true

class PrepTestOverview < ActiveRecord::Base
  validates :token, :permalink_slug, presence: true

  scope :permalink_slug_like_by_user_uid, lambda { |user_uid, permalink_slug|
      where(user_uid: user_uid)
      .where(ActiveRecord::Base.sanitize_sql_array(['permalink_slug LIKE ?', "#{permalink_slug}/%"])) 
  }
end
