# frozen_string_literal: true

module MeSalva
  module Delivery
    module Drivers
      module Correios
        class CorreiosTracking < DeliveryTracking
          include MeSalva::Delivery::Drivers::Correios::CorreiosClient
          include MeSalva::Delivery::Drivers::Correios::CorreiosTrackingErrors

          def all_events
            find_object_events
            return all_events_json if no_errors? && object_found?

            object_not_found_json
          end

          def posted?
            find_object_events
            @event_type = 'posted'
            return posted_event_json if no_errors? && event_found?

            return posted_event_not_found if object_found? && event_not_found?

            object_not_found_json
          end

          def out_for_delivery?
            find_object_events
            @event_type = 'out for delivery'
            return out_for_delivery_event_json if no_errors? && event_found?

            return out_for_delivery_event_not_found if object_found? && event_not_found?

            object_not_found_json
          end

          def delivered?
            find_object_events
            @event_type = 'delivered'
            return delivered_event_json if no_errors? && event_found?

            return delivered_event_not_found if object_found? && event_not_found?

            object_not_found_json
          end

          private

          def find_object_events
            @response = HTTParty.post(api_url(:ArEletronico),
                                      basic_auth: basic_auth,
                                      headers: api_header(:json),
                                      body: complete_body)
            find_error
            treat_fields
            treat_values
            treat_events
            @treated_events = events.map { |event| event.slice(*PERMITED_FIELDS).symbolize_keys }
          end

          def find_error
            @error = @response[0]['mensagem']
          end

          def posted_event
            filter_event('posted')
          end

          def out_for_delivery_event
            filter_event('out for delivery')
          end

          def delivered_event
            filter_event('delivered')
          end

          def filter_event(event_type)
            @treated_events.select { |event| event[:description] == event_type }[0]
          end

          def all_events_json
            { tracking_code: tracking_code,
              message: 'OBJECT_FOUND',
              events: @treated_events }
          end

          def object_not_found_json
            { tracking_code: tracking_code,
              message: 'OBJECT_NOT_FOUND',
              events: [] }
          end

          def posted_event_json
            event_object_found('POST', posted_event)
          end

          def out_for_delivery_event_json
            event_object_found('OUT_FOR_DELIVERY', out_for_delivery_event)
          end

          def delivered_event_json
            event_object_found('DELIVERED', delivered_event)
          end

          def event_object_found(event_type, post_event)
            { tracking_code: tracking_code,
              message: event_type,
              status: true,
              event: { date: post_event[:date],
                       unity: post_event[:unity],
                       city: post_event[:city],
                       state: post_event[:state] } }
          end

          def posted_event_not_found
            event_not_found('POST')
          end

          def out_for_delivery_event_not_found
            event_not_found('OUT_FOR_DELIVERY')
          end

          def delivered_event_not_found
            event_not_found('DELIVERED')
          end

          def event_not_found(event_type)
            { tracking_code: tracking_code,
              message: event_type,
              status: false,
              event: {} }
          end

          def complete_body
            {objetos: [tracking_code]}.to_json
          end

          def events
            @response[0]['eventos']
          end

          def object_found?
            @treated_events.count.positive?
          end

          def event_found?
            filter_event(event_type).present? && filter_event(event_type)[:description] == event_type
          end

          def event_not_found?
            !event_found?
          end

          def treat_fields
            events.each do |event|
              event['description'] = event.delete('descricaoEvento')
              event['date'] = event.delete('dataEvento')
              event['unity'] = event.delete('nomeUnidade')
              event['city'] = event.delete('municipio')
              event['state'] = event.delete('uf')
            end
          end

          def treat_values
            events.each do |event|
              event['description'] = description_translation(event['description'])
            end
          end

          def treat_events
            events.delete_if { |key| key['description'].nil? }
          end

          def description_translation(description)
            case description
            when 'Entregue'
              'delivered'
            when 'Saiu para entrega ao destinatário'
              'out for delivery'
            when 'Postado'
              'posted'
            end
          end
        end
      end
    end
  end
end
