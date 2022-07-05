# frozen_string_literal: true

module SimplybookAssertionHelper
  def connect_simplybook
    allow(HTTParty).to receive(:post)
      .with('https://user-api-v2.simplybook.me/admin/auth',
            headers: { 'Content-Type': 'application/json' },
            body: { "company": ENV['SIMPLYBOOK_COMPANY_LOGIN'],
                    "login": ENV['SIMPLYBOOK_USER_LOGIN'],
                    "password": ENV['SIMPLYBOOK_USER_PASSWORD'] }.to_json)
      .and_return(http_party_200_response(token))
  end
end
