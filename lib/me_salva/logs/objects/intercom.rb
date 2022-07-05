# frozen_string_literal: true

module MeSalva
  module Logs
    module Objects
      class Intercom
        def self.synchronization
          { iterations: 0,
            users_found: 0,
            users_updated: 0,
            student_leads_found: 0,
            student_leads_updated: 0,
            subscribers_found: 0,
            subscribers_updated: 0,
            unsubscribers_found: 0,
            unsubscribers_updated: 0,
            ex_subscribers_found: 0,
            ex_subscribers_updated: 0 }
        end
      end
    end
  end
end
