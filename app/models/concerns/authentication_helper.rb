# frozen_string_literal: true

module AuthenticationHelper
  def active_for_authentication?
    super && active?
  end
end
