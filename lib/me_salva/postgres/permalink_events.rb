# frozen_string_literal: true

module MeSalva
  module Postgres
    class PermalinkEvents
      def remove
        months = ENV['EVENT_MONTH_HISTORIZATION']
        sql = "created_at < now() - interval '#{months} months'"

        PermalinkEvent.where(sql).find_in_batches do |events|
          events.map(&:destroy)
        end
      end
    end
  end
end
