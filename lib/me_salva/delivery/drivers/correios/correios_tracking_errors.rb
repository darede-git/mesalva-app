# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        module CorreiosTrackingErrors
          def errors?
            raise t('activerecord.errors.libs.delivery.invalid_tracking_code') if invalid_tracking_code?

            false
          end

          def no_errors?
            !errors?
          end

          private

          def invalid_tracking_code?
            tracking_code.present? && tracking_code.match(/^[A-Z]{2}[0-9]{9}[A-Z]{2}$/).nil?
          end
        end
      end
    end
  end
end
