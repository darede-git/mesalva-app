# frozen_string_literal: true

require 'intercom'

module MeSalva
  module Crm
    def client
      ::Intercom::Client.new(token: ENV['INTERCOM_ACCESS_TOKEN'])
    end
  end
end
