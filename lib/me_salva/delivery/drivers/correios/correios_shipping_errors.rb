# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        module CorreiosShippingErrors
          include MeSalva::BrazilState
          include MeSalva::Delivery::Drivers::Correios::CorreiosClient

          def errors?
            raise t('activerecord.errors.libs.delivery.invalid_tangible_product') if invalid_tangible_product?
            raise t('activerecord.errors.libs.delivery.invalid_weight') if invalid_weight?
            raise t('activerecord.errors.libs.delivery.invalid_height') if invalid_height?
            raise t('activerecord.errors.libs.delivery.invalid_width') if invalid_width?
            raise t('activerecord.errors.libs.delivery.invalid_length') if invalid_length?
            raise t('activerecord.errors.libs.delivery.invalid_uf') if invalid_uf?

            false
          end

          def no_errors?
            !errors?
          end

          def service_type_error?
            raise t('activerecord.errors.libs.delivery.invalid_service') if invalid_service_code?
          end

          private

          def invalid_tangible_product?
            @tangible_product.nil?
          end

          def invalid_weight?
            @tangible_product.weight.nil? ||
              @tangible_product.weight <= 0
          end

          def invalid_height?
            @tangible_product.height.nil? ||
              @tangible_product.height <= 0
          end

          def invalid_width?
            @tangible_product.width.nil? ||
              @tangible_product.width <= 0
          end

          def invalid_length?
            @tangible_product.length.nil? ||
              @tangible_product.length <= 0
          end

          def invalid_uf?
            !UFS.include?(@uf)
          end

          def invalid_service_code?
            !valid_method?(@service_type)
          end
        end
      end
    end
  end
end
