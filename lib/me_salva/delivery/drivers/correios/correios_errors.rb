# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        module CorreiosErrors
          def errors?(error_code)
            @error_code = error_code
            raise t('activerecord.errors.libs.delivery.invalid_service') if invalid_service_code?
            raise t('activerecord.errors.libs.delivery.invalid_zipcode') if invalid_zipcode?

            false
          end

          def no_errors?(error_code)
            !errors?(error_code)
          end

          private

          def invalid_service_code?
            @error_code == 'AB-2016'
          end

          def invalid_zipcode?
            @error_code == 'AB-2009'
          end
        end
      end
    end
  end
end
