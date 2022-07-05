# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Login
          def initialize(**params)
            @user = params[:user]
            @client = params[:client]
          end

          def sign_up
            Client.new({ user: @user,
                         event_name: signup_name,
                         payload: signup_attributes })
                  .create
          end

          def sign_in
            Client.new({ user: @user,
                         event_name: signin_name,
                         payload: signin_attributes })
                  .create
          end

          private

          def signup_name
            "cadastro-me-salva-#{@client.downcase}"
          end

          def signup_attributes
            {
              cf_conta_ms_criada_em: @user.created_at.to_s,
              cf_mesalva_uid: @user.uid
            }
          end

          def signin_name
            "sign_in|#{@client.downcase}"
          end

          def signin_attributes
            {}
          end
        end
      end
    end
  end
end
