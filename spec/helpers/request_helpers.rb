# frozen_string_literal: true

module RequestHelpers
  include Authorization

  def authentication_headers_for(user, platform = nil)
    @resource = user
    @request.headers[:client] = 'WEB'
    auth_header = create_new_auth_token(platform)
    @request.headers.merge!(auth_header)
  end

  def add_custom_headers(custom_headers)
    @request.headers.merge!(custom_headers)
  end

  def http_party_404_response
    @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
    @response_object = Net::HTTPNotFound.new('1.1', 404, 'Not found')
    allow(@response_object).to receive_messages(body: "{foo:'bar'}")
    @parsed_response = -> { { "foo" => "bar" } }

    HTTParty::Response.new(@request_object,
                           @response_object,
                           @parsed_response)
  end

  def http_party_200_response(body)
    @request_object = HTTParty::Request.new Net::HTTP::Get, '/'
    @response_object = Net::HTTPOK.new('1.1', 200, 'Ok')
    allow(@response_object).to receive_messages(body: body)
    @parsed_response = -> { body }

    HTTParty::Response.new(@request_object,
                           @response_object,
                           @parsed_response)
  end
end
