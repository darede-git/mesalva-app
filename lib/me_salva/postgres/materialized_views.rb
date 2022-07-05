# frozen_string_literal: true

require 'active_record'

module MeSalva
  module Postgres
    class MaterializedViews
      MATERIALIZED_VIEWS = %w[vw_node_seconds_duration
                              vw_node_medium_count].freeze

      def refresh
        MATERIALIZED_VIEWS.each do |view|
          sql_refresh_for(view)
        end
      end

      private

      def sql_refresh_for(view)
        sql = "REFRESH MATERIALIZED VIEW #{view}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
  end
end
