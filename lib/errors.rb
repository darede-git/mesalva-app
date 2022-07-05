# frozen_string_literal: true

class Errors
  def initialize(exception)
    @exception = exception
  end

  def notify_engineers(message, custom_attributes = nil)
    NewRelic::Agent.add_custom_attributes(custom_attributes) unless custom_attributes.nil?
    NewRelic::Agent.notice_error(@exception, message: message)
  end
end
