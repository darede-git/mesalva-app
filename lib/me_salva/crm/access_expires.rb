# frozen_string_literal: true

module MeSalva
  module Crm
    class AccessExpires
      include RdStationHelper
      include CrmEvents

      def initialize; end

      def event_expire_access(days = nil)
        case days
        when 0
          event_all_access_today
        when 30
          event_all_access_expires_30_days
        end
      end

      private

      def event_all_access_today
        Access.active.expires_today.each do |access|
          send_rd_station_event(event: :access_renewal_today,
                                params: { user: access.user,
                                          package: access.package })
          create_crm('renewal_today', access.user, access.order)
        end
      end

      def event_all_access_expires_30_days
        mes_vencimento = (Date.today + 30.days)

        acessos = Access.active.where("to_char(expires_at, 'YYYY-MM-DD') = ?", [mes_vencimento])

        acessos.each do |access|
          send_rd_station_event(event: :access_renewal_30_days,
                                params: { user: access.user,
                                          package: access.package })

          create_crm('renewal_30_days', access.user, access.order)
        end
      end
    end
  end
end
