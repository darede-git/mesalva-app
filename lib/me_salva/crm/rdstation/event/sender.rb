# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class Sender
          ALLOWED_EVENTS =
            { campaign_sign_up: { class: :Campaign, method: :sign_up },
              checkout_client: { class: :Checkout, method: :client },
              checkout_ex_client: { class: :Checkout, method: :ex_client },
              checkout_repurchase_client: { class: :Checkout, method: :repurchase_client },
              checkout_upsell_client: { class: :Checkout, method: :upsell_client },
              checkout_view: { class: :Checkout, method: :view },
              sign_up: { class: :Login, method: :sign_up },
              sign_in: { class: :Login, method: :sign_in },
              study_objective_change: { class: :StudyObjective, method: :change },
              payment_bank_slip_generated: { class: :Payment, method: :bank_slip_generated },
              payment_bank_slip_expires_today: { class: :Payment,
                                                 method: :bank_slip_expires_today },
              payment_bank_slip_expired: { class: :Payment, method: :bank_slip_expired },
              payment_card_error: { class: :Payment, method: :card_error },
              payment_refused: { class: :Payment, method: :refused },
              payment_success: { class: :Payment, method: :success },
              prep_test_answer: { class: :PrepTest, method: :answer },
              subscription_unsubscribe: { class: :Subscription, method: :unsubscribe },
              access_renewal_today: { class: :Access, method: :renewal_today },
              access_renewal_30_days: { class: :Access, method: :renewal_30_days },
              user_settings: { class: :User, method: :settings } }
            .freeze

          def initialize(**params)
            @params = params[:params]
            @event = params[:event]
          end

          def send_event
            return unless valid_event?

            event_lib.new(@params).send(event_method)
          end

          private

          def valid_event?
            ALLOWED_EVENTS[@event].present?
          end

          def event_class
            ALLOWED_EVENTS[@event][:class]
          end

          def event_method
            ALLOWED_EVENTS[@event][:method]
          end

          def event_lib
            "MeSalva::Crm::Rdstation::Event::#{event_class}".constantize
          end
        end
      end
    end
  end
end
