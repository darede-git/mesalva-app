# frozen_string_literal: true

def t(string, options = {})
  I18n.t(string, options)
end

def mock_http_party(response)
  allow(HTTParty).to receive_message_chain(:get, :parsed_response)
    .and_return(response)
end
