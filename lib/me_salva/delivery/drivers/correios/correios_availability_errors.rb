# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        module CorreiosAvailabilityErrors
          ERRORS = { invalid_service: 'AB-2016',
                     invalid_zipcode: 'AB-2009' }.freeze

          def errors?
            raise t('activerecord.errors.libs.delivery.invalid_service') if invalid_service_code?
            raise t('activerecord.errors.libs.delivery.invalid_zipcode') if invalid_zipcode?

            false
          end

          def no_errors?
            !errors?
          end

          private

          def invalid_service_code?
            error == ERRORS[:invalid_service]
          end

          def invalid_zipcode?
            error == ERRORS[:invalid_zipcode]
          end
        end
      end
    end
  end
end
