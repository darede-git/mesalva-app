# frozen_string_literal: true

require 'me_salva/crm/users'

class BaseIntercomUserWorker
  include Sidekiq::Worker

  def intercom_action(verb, resource_id, resource_name, attributes = nil)
    resource = resource_name.constantize.find(resource_id)
    return if resource_name == 'User' && resource.crm_email.nil?
    return MeSalva::Crm::Users.new.send(verb.to_sym, resource) unless attributes

    attributes = Hash[attributes].symbolize_keys
    MeSalva::Crm::Users.new.send(verb.to_sym, resource, attributes)
  end
end
