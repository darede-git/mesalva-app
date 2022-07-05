# frozen_string_literal: true

require 'intercom'
require 'me_salva/crm/client'
require 'active_support/core_ext/enumerable'

module MeSalva
  module Crm
    class Events
      include MeSalva::Crm
      def initialize; end

      ALLOWED_EVENTS = %w[login
                          lesson_watch_web
                          lesson_watch_android
                          lesson_watch_ios
                          text_read_web
                          text_read_android
                          text_read_ios
                          exercise_answer_web
                          exercise_answer_android
                          exercise_answer_ios
                          download_web
                          download_android
                          download_ios
                          content_rate_positive
                          content_rate_neutral
                          content_rate_negative
                          plans_view
                          checkout_view
                          checkout_submit_credit_card
                          checkout_submit_bank_slip
                          checkout_success
                          checkout_fail
                          bank_slip_paid
                          boleto_expired
                          account_upgrade
                          account_downgrade
                          account_upsell
                          account_downsell
                          wpp_boleto_gerado
                          wpp_boleto_vence-hoje
                          wpp_boleto_vencido
                          wpp_cartao_error
                          renewal_30_days
                          renewal_today
                          essay_submission].freeze

      def self.allowed_event?(event)
        ALLOWED_EVENTS.include? event
      end

      private_constant :ALLOWED_EVENTS

      def create(event, user_uid, date, meta)
        return false if not_allowed(event)

        client.events.create(event_name: event,
                             user_id: user_uid,
                             created_at: date,
                             metadata: meta)
      end

      private

      def not_allowed(event)
        ALLOWED_EVENTS.exclude?(event)
      end
    end
  end
end
