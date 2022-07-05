
class Bff::User::BffUserBaseController < ApplicationController
  before_action :authenticate_user
end
