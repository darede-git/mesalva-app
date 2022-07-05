# frozen_string_literal: true

class Instructor < ActiveRecord::Base
  belongs_to :user

  has_many :instructor_users
  has_many :users, through: :instructor_users

  after_create :assign_token_to_user

  def assign_token_to_user
    return unless user.token.nil?

    user.regenerate_token
  end
end
