# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Subscription
          def initialize(**params)
            @subscription = params[:subscription]
          end

          def unsubscribe
            Client.new({ user: user,
                         event_name: 'assinatura-cancelada-pelo-usuario',
                         payload: default_attributes }).create
          end

          private

          def default_attributes
            unless quiz
              return {
                cf_nome_do_produto: @subscription.orders.first.package_name
              }
            end
            {
              cf_nome_do_produto: @subscription.orders.first.package_name,
              cf_motivo_do_cancelamento_assinatura: reason,
              cf_grau_de_satisfacao_cancelamento: satisfaction
            }
          end

          def reason
            quiz['question1.answer']
          end

          def satisfaction
            quiz['question2.answer']
          end

          def quiz
            @subscription.orders&.first&.cancellation_quiz&.quiz
          end

          def user
            @subscription.user
          end
        end
      end
    end
  end
end
