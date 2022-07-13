# frozen_string_literal: true

RSpec.describe Bff::Admin::Users, type: :controller do
  include PermissionHelper
  describe "POST #anonymous_user " do
    before { user_session }
    before { grant_test_permission('anonymize_user') }
    context 'with a user' do
      let!(:usuario) { create(:user) }
      context 'with a package' do
        let!(:pacote) { create(:package_valid_with_price) }
        context 'with orders' do
          let!(:order) { create(:order, package_id: pacote.id, user_id: usuario.id) }
          let!(:order2) { create(:order, package_id: pacote.id, user_id: usuario.id) }
          context 'with crm events' do
            let!(:crm) { create(:crm_event, user_id: usuario.id) }
            context 'with addresses' do
              let!(:address) { create(:address, addressable_id: usuario.id, addressable_type: 'User') }
              let!(:address2) { create(:address, addressable_id: order.id, addressable_type: 'Order') }
              context 'with an accesses' do
                let!(:acesso) do
                  create(:access,
                         expires_at: Date.today + 30.days,
                         user_id: usuario.id,
                         package_id: pacote.id,
                         gift: false,
                         active: false)
                end
                it "anonymize user information", :vcr do
                  delete :anonymize_user, params: { uid: usuario.uid }

                  expect(response).to have_http_status(:no_content)

                  expect(usuario.reload).to have_attributes(name: "Erased User #{date_now}",
                                                            uid: email_erased,
                                                            email: email_erased,
                                                            crm_email: email_erased)

                  expect(crm.reload).to have_attributes(ip_address: '000.000.000.000',
                                                        user_email: email_erased,
                                                        user_name: "Erased User #{date_now}")

                  expect(order.reload).to have_attributes(email: email_erased,
                                                          cpf: '00000000000',
                                                          phone_number: '000000000',
                                                          phone_area: '00')

                  expect(order2.reload).to have_attributes(email: email_erased,
                                                           cpf: '00000000000',
                                                           phone_number: '000000000',
                                                           phone_area: '00')

                  expect(address.reload).to have_attributes(street: 'Erased',
                                                            street_number: 0,
                                                            street_detail: 'Erased',
                                                            neighborhood: 'Erased',
                                                            city: 'Erased',
                                                            zip_code: '00000-000',
                                                            state: 'Erased',
                                                            area_code: '00',
                                                            phone_number: '000000000')

                  expect(address2.reload).to have_attributes(street: 'Erased',
                                                             street_number: 0,
                                                             street_detail: 'Erased',
                                                             neighborhood: 'Erased',
                                                             city: 'Erased',
                                                             zip_code: '00000-000',
                                                             state: 'Erased',
                                                             area_code: '00',
                                                             phone_number: '000000000')
                end
              end
              context 'user access gift true' do
                let!(:acesso) do
                  create(:access,
                         expires_at: Date.today + 30.days,
                         user_id: usuario.id,
                         package_id: pacote.id,
                         gift: true,
                         active: false)
                end

                let!(:order3) do
                  create(:order, package_id: pacote.id,
                                 user_id: usuario.id,
                                 status: 2)
                end

                it "returns error for not being able to anonymize the user", :vcr do
                  delete :anonymize_user, params: { uid: usuario.uid }
                  expect(response).to have_http_status(:unprocessable_entity)
                  expect(parsed_response['errors'].first).to eq(t('activerecord.errors.models.user.has_order_history'))
                end
              end
            end
          end
        end
      end
    end
  end

  def date_now
    DateTime.now.strftime('%Y-%m-%d_%H:%M')
  end

  def email_erased
    "erased-user-#{date_now}@mesalva.org".gsub(' ', '')
  end
end
