# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Checkout
          def initialize(**params)
            @user = params[:user]
            @package = params[:package]
            
          end

          def view
            Client.new({ user: @user,
                         event_name: name('checkout_view'),
                         payload: attributes })
                  .create
          end

          def client
            Client.new({ user: @user,
                         event_name: name('checkout_client'),
                         payload: attributes })
                  .create
          end

          def ex_client
            Client.new({ user: @user,
                         event_name: name('checkout_ex_client'),
                         payload: attributes })
                  .create
          end

          def repurchase_client
            Client.new({ user: @user,
                         event_name: name('checkout_repurchase_client'),
                         payload: attributes })
                  .create
          end

          def upsell_client
            Client.new({ user: @user,
                         event_name: name('checkout_upsell_client'),
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
