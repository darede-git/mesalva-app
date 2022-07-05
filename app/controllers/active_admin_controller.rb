# frozen_string_literal: true

class ActiveAdmin::BaseController
  http_basic_authenticate_with(name: ENV['ACTIVE_ADMIN_USERNAME'],
                               password: ENV["ACTIVE_ADMIN_PASSWORD"])
end
