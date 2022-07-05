# frozen_string_literal: true

require 'me_salva/crm/events'
require 'me_salva/crm/users'

class CreateIntercomEventWorker
  include Sidekiq::Worker

  def perform(params)
    time = Rails.env.test? ? Time.at(1_475_242_445) : Time.now
    MeSalva::Crm::Events.new.create(params[0], params[1], time,
                                    permitted_attributes(params[2]))
  rescue Intercom::ResourceNotFound
    user = User.find_by_uid(params[1])
    return if user.crm_email.nil?

    begin
      MeSalva::Crm::Users.new.create(user)
    rescue StandardError
      nil
    end
  end
end

def permitted_attributes(hash)
  blacklist.each_with_object(hash) { |k| hash.delete(k) }
end

def blacklist
  %w[permalink_node permalink_node_id permalink_node_type permalink_node_slug
     permalink_node_module permalink_node_module_id permalink_node_module_slug
     permalink_item permalink_item_id permalink_item_type permalink_item_slug
     permalink_medium_id permalink_medium_type permalink_medium_slug
     permalink_answer_id permalink_answer_correct content_rating]
end
