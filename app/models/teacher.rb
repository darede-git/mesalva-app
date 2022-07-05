# frozen_string_literal: true

class Teacher < Member
  devise :invitable, :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  include AuthenticationHelper
  include PasswordResetHelper

  has_many :comments, as: :commentable
  has_many :node_modules, as: :instructor

  validates :active, inclusion: { in: [true, false] }
end
