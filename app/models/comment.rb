# frozen_string_literal: true

class Comment < ActiveRecord::Base
  include TokenHelper

  default_scope { where active: true }

  before_validation :generate_token, on: :create

  belongs_to :commentable, polymorphic: true
  belongs_to :commenter, polymorphic: true

  validates :commentable, :text, presence: true, allow_blank: false
  validates :commenter, :text, presence: true, allow_blank: false

  validates :active, inclusion: { in: [true, false] }
  validates :token, presence: true, uniqueness: true

  scope :by_medium, ->(medium) { where commentable: medium }

  def author_name
    commenter&.name
  end

  def author_image
    commenter&.image
  end
end
