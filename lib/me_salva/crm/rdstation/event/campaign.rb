# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Campaign
          def initialize(**params)
            @user = params[:user]
            @campaign_name = params[:campaign_name]
          end

          def sign_up
            Client.new({ user: @user,
                         event_name: sign_up_name,
                         payload: sign_up_attributes })
                  .create
          end

          private

          def sign_up_name
            "campaign_sign_up|#{@campaign_name}"
          end

          def sign_up_attributes
            { cf_campaign_view_name: @campaign_name }
          end
        end
      end
    end
  end
end
