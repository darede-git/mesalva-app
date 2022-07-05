# frozen_string_literal: true

module InvitationAssertionHelper
  def assert_invite_creation(resource_name)
    expect do
      post :create, params: { email: 'invite@email.com', name: 'invite' }
    end.to change(resource_name.constantize, :count).by(1)

    expect_valid_response('created')
  end

  def assert_accept_invite(password, password_confirmation,
                           token, error_message, http_status)
    put :update, params: { password: password,
                           password_confirmation: password_confirmation,
                           invitation_token: token }

    expect_valid_response(http_status)
    expect(parsed_response).to eq(error_message)
  end

  def expect_valid_response(http_status)
    expect(response.content_type).to eq("application/json")
    expect(response).to have_http_status(http_status.to_sym)
  end
end
