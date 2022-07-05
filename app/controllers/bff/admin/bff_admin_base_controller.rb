# frozen_string_literal: true

class Bff::Admin::BffAdminBaseController < ApplicationController
  before_action :authenticate_permission
end
