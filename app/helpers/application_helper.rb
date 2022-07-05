# frozen_string_literal: true

module ApplicationHelper
  def admin_teacher_access_verification
    return access_denied unless admin_signed_in? || teacher_signed_in?
  end

  def access_denied
    super
  end

  def v2?
    request.headers['Api-Version'] == '2'
  end
end
