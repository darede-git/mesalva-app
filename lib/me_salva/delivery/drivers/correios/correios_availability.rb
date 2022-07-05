# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        class CorreiosAvailability < DeliveryAvailability
          include MeSalva::Delivery::Drivers::Correios::CorreiosClient
          include MeSalva::Delivery::Drivers::Correios::CorreiosErrors

          def service_available?(service_type)
            @service_type = service_type
            request = HTTParty.post(api_url(:Abrangencia),
                                    basic_auth: basic_auth,
                                    headers: api_header(:xml),
                                    body: complete_body)
            @response = request['Envelope']['Body']['consultarAbrangenciaDoServicoResponse']['retorno']
            availability unless errors?(@response['codigoRetorno'])
          end

          def services_available
            services_verified = []
            DELIVERY_METHODS.each_key do |delivery_method|
              if service_available?(delivery_method.to_s) && no_errors?(@response['codigoRetorno'])
                services_verified << delivery_method.to_s
              end
            end
            { services_available: services_verified }
          end

          private

          def complete_body
            "#{header}#{body}"
          end

          def header
            '<x:Envelope xmlns:x="http://schemas.xmlsoap.org/soap/envelope/"
             xmlns:ser="http://service.abrangencia.cws.correios.com.br/"><x:Header/>'
          end

          def body
            "<x:Body><ser:consultarAbrangenciaDoServico>
            <listaServico>#{@service_type}</listaServico>
            <cepOrigem>#{sender_zipcode}</cepOrigem>
            <cepDestino>#{recipient_zipcode}</cepDestino>
            </ser:consultarAbrangenciaDoServico></x:Body></x:Envelope>"
          end

          def availability
            @response['abrangencia']['listaServicos']['disponibilidade'] == 'true'
          end
        end
      end
    end
  end
end
