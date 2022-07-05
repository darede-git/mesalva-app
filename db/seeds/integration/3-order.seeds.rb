require "me_salva/payment/iugu/data"

package = Package.find(100)

order = Order.create!(package_id: package.id,
                      user_id: 1,
                      broker: "iugu",
                      currency: "BRL",
                      checkout_method: "bank_slip",
                      installments: 1,
                      email: "email@teste.com",
                      cpf: "69430742884",
                      nationality: "Brasileiro",
                      token: "AoXz1Y4kWW8q9WdB",
                      price_paid: 10.00,
                      address_attributes:
                      { street: "Rua Padre Chagas",
                        street_number: 79,
                        street_detail: "302",
                        neighborhood: "Moinhos de Vento",
                        city: "Porto Alegre",
                        zip_code: "91920-000",
                        state: "RS",
                        country: "Brasil",
                        area_code: "11",
                        phone_number: "979911992"
                      })

order2 = Order.create!(package_id: package.id,
                      user_id: 1,
                      broker: "iugu",
                      currency: "BRL",
                      checkout_method: "bank_slip",
                      installments: 1,
                      email: "email@teste.com",
                      cpf: "69430742884",
                      nationality: "Brasileiro",
                      token: "AoXz1Y4kWW8q9Wd1",
                      price_paid: 10.00,
                      address_attributes:
                      { street: "Rua Padre Chagas",
                        street_number: 79,
                        street_detail: "302",
                        neighborhood: "Moinhos de Vento",
                        city: "Porto Alegre",
                        zip_code: "91920-000",
                        state: "RS",
                        country: "Brasil",
                        area_code: "11",
                        phone_number: "979911992"
                      })

  # Pagamento em assinatura
  education_segment = Node.find_by_slug('enem-e-vestibulares')

  subscription_package = Package.create!(id: 2380,
                                         name: "Assinatura",
                                         expires_at: "",
                                         duration: 1,
                                         active: "true",
                                         subscription: "true",
                                         description: "Descrição da assinatura",
                                         form: 'MuV5ud',
                                         info: ["info 1", "info 2"],
                                         max_payments: 1,
                                         essay_credits: 10,
                                         private_class_credits: 0,
                                         unlimited_essay_credits: false,
                                         node_ids: [3],
                                         education_segment_slug: education_segment.slug,
                                         sales_platforms: ['web'],
                                         prices_attributes:[{ price_type: "credit_card",
                                                              value: 10.00}])

  subscription = Subscription.create(user_id: 1,
                                     active: true,
                                     token: 'BoYz1Z4kBB8q9WdA',
                                     broker_id: "74FCA99C15574083AA0E9F400148A68C")

  Order.create(package_id: subscription_package.id,
               user_id: 1,
               broker: "iugu",
               currency: "BRL",
               checkout_method: "credit_card",
               installments: 1,
               status: 2,
               email: "email@teste.com",
               cpf: "69430742884",
               nationality: "Brasileiro",
               token: "AoXz1Y4kWW8q9Wd4",
               price_paid: 10.00,
               subscription_id: subscription.id,
               address_attributes:
               { street: "Rua Padre Chagas",
                 street_number: 79,
                 street_detail: "302",
                 neighborhood: "Moinhos de Vento",
                 city: "Porto Alegre",
                 zip_code: "91920-000",
                 state: "RS",
                 country: "Brasil",
                 area_code: "11",
                 phone_number: "979911992"
               })

# Pagamento para ser reembolsado
order4 = Order.create!(package_id: package.id,
                       user_id: 1,
                       broker: "iugu",
                       currency: "BRL",
                       checkout_method: "bank_slip",
                       installments: 1,
                       email: "email@teste.com",
                       cpf: "69430742884",
                       broker_invoice: "8BB9330FC6224AD68F68377CC44862E1",
                       nationality: "Brasileiro",
                       token: "AoXz1Y4kWW8q9WdC",
                       price_paid: 10.00,
                       phone_area: "51",
                       phone_number: '979911992',
                       address_attributes:
                       { street: "Rua Padre Chagas",
                         street_number: 79,
                         street_detail: "302",
                         neighborhood: "Moinhos de Vento",
                         city: "Porto Alegre",
                         zip_code: "91920-000",
                         state: "RS",
                         country: "Brasil"
                       })
order4.update(broker: 'pagarme')
payment = FactoryBot.create(:payment, :card, order: order4, payment_method: 'bank_slip',
                            card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
charging = MeSalva::Payment::Pagarme::Charge.new(payment, 'custom billing name').perform
order4.update(expires_at: charging.current_period_end)
payment.update(
 pagarme_transaction_attributes: { transaction_id: charging.id,
                                   order_payment: payment }
)
payment.state_machine.transition_to(:captured)

payment = FactoryBot.create(:payment, :card, order: order4, payment_method: 'bank_slip',
                            card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
charging = MeSalva::Payment::Pagarme::Charge.new(payment, 'custom billing name').perform
order4.update(expires_at: charging.current_period_end)
payment.update(
 pagarme_transaction_attributes: { transaction_id: charging.id,
                                   order_payment: payment }
)
payment.state_machine.transition_to(:captured)

# Usado para criar uma nova invoice pendente no broker da iugu
MeSalva::Payment::Iugu::Data.new(order,
                           User.find(1),
                           nil,
                           "Nome teste",
                           "email@teste.com").persist

MeSalva::Payment::Iugu::Data.new(order2,
                           User.find(1),
                           nil,
                           "Nome teste",
                           "email@teste.com").persist

package.features = [FactoryBot.create(:feature)]
package.save
