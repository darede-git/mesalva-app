# frozen_string_literal: true

RSpec.shared_examples 'updates the logged user' do
  it 'updates the user attributes' do
    expect(UpdateIntercomUserWorker).not_to receive(:perform_async)

    put :update, params: { birth_date: 'Tue, 26 Feb 1994',
                           name: 'João Bolão',
                           image: 'data:image/jpeg;base64,iVBORw0KGgoAAAANSUh'\
                           'EUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP4z8DwHwAF'\
                           'AAH/VscvDQAAAABJRU5ErkJggg==' }
    assert_headers_for(user_role)
    assert_action_response(success_response, :ok)
  end
end

RSpec.shared_examples 'a email update for social provider' do |providers|
  providers.each do |provider|
    before { user.update(provider: provider) }
    let(:new_email) { 'novoemail@mesalva.com' }

    context 'with nil email' do
      before { user.update(email: nil) }

      it 'permit updates the email' do
        expect do
          put :update, params: { id: user, email: new_email }
        end.to change { user.reload.email }
          .from(user.reload.email)
          .to(new_email)

        assert_headers_for(user)
        assert_type_and_status(:ok)
      end
    end

    context 'with email' do
      it 'not permit updates the email' do
        expect do
          put :update, params: { id: user, email: new_email }
        end.to_not change(user.reload, :email)

        assert_headers_for(user)
        assert_type_and_status(:forbidden)
      end
    end
  end
end
