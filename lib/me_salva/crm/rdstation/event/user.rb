# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class User
          def initialize(**params)
            @user = params[:user]
            @key = params[:key]
            @value = params[:value]
          end

          def settings
            Client.new({ user: @user,
                         event_name: name('user-setting-changed'),
                         payload: attributes })
                  .create
          end

          private

          def name(event)
            "#{event}|#{@key}"
          end

          def attributes
            { @key => @value }
          end
        end
      end
    end
  end
end
