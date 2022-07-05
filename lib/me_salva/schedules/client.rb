module MeSalva
  module Schedules
    class Client
      def initialize
        response = HTTParty.post('https://user-api-v2.simplybook.me/admin/auth',
                                 headers: { 'Content-Type': 'application/json' },
                                 body: { "company": ENV['SIMPLYBOOK_COMPANY_LOGIN'],
                                         "login": ENV['SIMPLYBOOK_USER_LOGIN'],
                                         "password": ENV['SIMPLYBOOK_USER_PASSWORD'] }.to_json)
        @token = response['token']
      end

      def authenticated_headers
        {
          'Content-Type': 'application/json',
          'X-Company-Login': ENV['SIMPLYBOOK_COMPANY_LOGIN'],
          'X-Token': @token
        }
      end

      def get_request(route)
        HTTParty.get("https://user-api-v2.simplybook.me/admin/#{route}", headers: authenticated_headers)
      end
    end
  end
end
