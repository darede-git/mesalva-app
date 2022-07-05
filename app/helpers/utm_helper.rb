# frozen_string_literal: true

module UtmHelper
  def request_header(key)
    request.headers[key] if defined?(request) && request
  end

  def utm_attr
    utms = {}
    utm_attributes.each do |header|
      utms[header] =
        request_header("HTTP_#{header.to_s.upcase}") || request_header(header)
    end
    utms
  end

  def utm_attributes
    %i[utm_source utm_medium utm_term utm_content utm_campaign]
  end
end
