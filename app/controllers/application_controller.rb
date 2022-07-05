# frozen_string_literal: true

require 'pagarme'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ApplicationHelper
  include PaginationHelper
  include ResponseHelper
  include Security
  include Authorization
  include SerializationHelper
  include Rails::Pagination
  before_action :request_validation
  before_action :add_newrelic_headers
  before_action :expires_now
  before_action :cast_empty_params, only: %i[create update]
  skip_after_action :update_auth_header, unless: :devise_controller?

  private

  # On Rails 4.2, empty params were converted to nil. On Rails 5, it is cast
  # to an empty string
  # ActiveRecord will not change relationships when the value is an empty
  # string (e.g item.medium_ids = ""), but given mobile clients will send
  # empty values, we need to fix this behavior by converting those values to
  # nil.
  def cast_empty_params
    %i[node_module_ids medium_ids item_ids node_ids].each do |foreign_key|
      params[foreign_key] = nil if params[foreign_key] == ""
    end
  end

  def add_newrelic_headers
    uid = request.headers['uid']
    NewRelic::Agent.add_custom_attributes({ user: uid }) unless uid.nil?
  end

  def request_validation
    return if controller_path.starts_with?('panel')

    if postback_request?
      return render_forbidden('errors.message.postback') \
                                                    unless authorized_postback?
    else
      return render_forbidden('errors.messages.client') \
                                                    unless authorized_client?
    end
  end

  def authorized_postback?
    return true if %w[typeform health rdstation].include?(params[:action])
    return revenuecat_signature? if postback_request? && revenuecat_signature?

    if postback_request? && pagarme_request?
      MeSalva::Payment::Pagarme::Postback.valid_signature?(request)
    end
  end

  def postback_request?
    controller_name == 'postbacks'
  end

  def authorized_client?
    return true if request.user_agent == 'Rails Testing'

    return true if development_debug_request?

    ApiAuth.authentic?(request, client_app_token, clock_skew: 2.hours)
  end

  def development_debug_request?
    ENV['DEBUG_APP_TOKEN'].present? && client_name == 'DEBUG' &&
      request.headers['access-token'] == ENV['DEBUG_APP_TOKEN']
  end

  def client_app_token
    ENV["#{client_id}_APP_TOKEN"]
  end

  def client_id
    ApiAuth.access_id(request)
  end

  def revenuecat_signature?
    return false unless revenuecat_request?

    MeSalva::Payment::Revenuecat::Postback.valid_signature?(request)
  end

  def pagarme_request?
    params['action'] == 'create'
  end

  def revenuecat_request?
    params['action'] == 'revenuecat'
  end
end
