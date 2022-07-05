# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Access
          def initialize(**params)
            @user = params[:user]
            @package = params[:package]
          end

          def renewal_today
            Client.new({ user: @user,
                          event_name: name('wpp-renovacao-0-dias'),
                          payload: attributes })
                  .create
          end

          def renewal_30_days
              Client.new({ user: @user,
                            event_name: name('wpp-renovacao-30-dias'),
                            payload: attributes })
                    .create
            end

          private

          def name(event)
            "#{event}|#{@package.sku}"
          end

          def attributes
              { cf_package_name: @package.name,
                cf_package_slug: @package.slug,
                cf_package_duration: @package.duration.to_s,
                cf_package_sku: @package.sku }
          end
        end
      end
    end
  end
end
