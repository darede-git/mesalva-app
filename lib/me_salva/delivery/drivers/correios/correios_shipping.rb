# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        class CorreiosShipping < DeliveryShipping
          include MeSalva::Delivery::Drivers::Correios::CorreiosClient
          include MeSalva::Delivery::Drivers::Correios::CorreiosShippingErrors

          def initialize(**params)
            super(params)
            find_errors
            @services_information = []
          end

          def cheapest_service
            find_services_information
            return none_json unless at_least_one_service_available?

            cheapest_service_found
          end

          def service_information(service_name)
            @service_type = service_name
            service_type_error?
            find_service_information
            return none_json unless service_found?

            service_found
          end

          private

          def service_json
            shipping_information = service_shipping
            @service_information = { service: @service_type,
                                     availability: true,
                                     price: shipping_information['Valor'].gsub(',', '.').to_f,
                                     time_in_days: shipping_information['PrazoEntrega'].to_i }
          end

          def find_services_information
            available_methods.each do |service_type|
              @service_type = service_type
              @services_information << service_json if service_able_to_use
            end
          end

          def find_service_information
            service_json if service_able_to_use
          end

          def cheapest_service_found
            @services_information.min_by { |service| service[:price] }
          end

          def service_found
            @service_information
          end

          def service_found?
            @service_information.present?
          end

          def specific_rules?
            @service_type == 'PAC' && @uf == 'RS'
          end

          def none_json
            { service: 'NONE' }
          end

          def service_able_to_use
            !specific_rules? && delivery_availability.service_available?(@service_type)
          end

          def find_errors
            errors?
          end

          def service_shipping
            request = HTTParty.post(api_url(:Calculador),
                                    headers: api_header(:urlencoded),
                                    body: body)
                              .parsed_response
            request['cResultado']['Servicos']['cServico']
          end

          def at_least_one_service_available?
            @services_information.count.positive?
          end

          def body
            { nCdEmpresa: ENV['CORREIOS_ADMIN_CODE'],
              sDsSenha: ENV['CORREIOS_PASSWORD'],
              nCdServico: method_code(@service_type),
              sCepOrigem: delivery_availability.sender_zipcode,
              sCepDestino: delivery_availability.recipient_zipcode,
              nVlPeso: tangible_product.weight.to_f,
              nCdFormato: 1,
              nVlComprimento: tangible_product.length.to_f,
              nVlAltura: tangible_product.height.to_f,
              nVlLargura: tangible_product.width.to_f,
              nVlDiametro: 0,
              sCdMaoPropria: "N",
              nVlValorDeclarado: 0,
              sCdAvisoRecebimento: "N" }.to_query
          end
        end
      end
    end
  end
end
