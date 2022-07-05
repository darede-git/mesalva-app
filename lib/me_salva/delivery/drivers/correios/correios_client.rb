# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        module CorreiosClient
          DELIVERY_METHODS = { PAC: 3298,
                               SEDEX: 3220 }
                             .freeze

          APIS = { Abrangencia: "https://cws.correios.com.br/cws/abrangenciaService/abrangenciaWS?wsdl",
                   ArEletronico: "https://apps3.correios.com.br/areletronico/v1/ars/eventos",
                   Calculador: "http://ws.correios.com.br/calculador/calcprecoprazo.asmx/CalcPrecoPrazo" }
                 .freeze

          HEADERS = { json: { "Content-Type" => "application/json" },
                      xml: { "Content-Type" => "text/xml" },
                      urlencoded: { "Content-Type" => "application/x-www-form-urlencoded" } }
                    .freeze

          USERNAME = ENV['CORREIOS_USERNAME']

          PASSWORD = ENV['CORREIOS_PASSWORD']

          CONTRACT_CODE = ENV['CORREIOS_CONTRACT_CODE']

          POST_CODE = ENV['CORREIOS_POST_CODE']

          def method_code(method)
            DELIVERY_METHODS[method.to_sym]
          end

          def available_methods
            DELIVERY_METHODS.keys.map(&:to_s)
          end

          def api_url(description)
            APIS[description.to_sym]
          end

          def api_header(description)
            HEADERS[description.to_sym]
          end

          def basic_auth
            { username: ENV['CORREIOS_USERNAME'], password: ENV['CORREIOS_PASSWORD'] }
          end
        end
      end
    end
  end
end
