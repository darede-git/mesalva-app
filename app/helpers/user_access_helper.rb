# frozen_string_literal: true

require 'me_salva/user/access'

module UserAccessHelper
  def create_access(user, package, **attr)
    MeSalva::User::Access.new.create(user, package, attr)
  end

  def contest_access(access)
    MeSalva::User::Access.new.contest(access)
  end
end
