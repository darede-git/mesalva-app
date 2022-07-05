# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Payment do
  let(:default_attributes) do
    {
      cf_checkout_celular: "(#{order.phone_area})#{order.phone_number}",
      cf_checkout_email: order.email,
      cf_data_da_ordem: order.created_at.to_s,
      cf_nome_do_produto: order.package_name
    }
  end
  let(:payment_attributes) do
    default_attributes.merge(cf_valor_ultima_ordem: order.price_paid.to_f.to_s)
  end
  let(:payment_attributes_success) do
    payment_attributes.merge(cf_package_sku: order.package.sku)
  end
  let(:subscription_attributes) do
    payment_attributes.merge(
      cf_acesso_expira_em: (Time.now + 40.days).to_s,
      cf_subscription_id_pagarme: pagarme_subscription_id
    )
  end
  let(:pagarme_subscription_id) do
    order.subscription.pagarme_subscription.pagarme_id
  end
  let(:refused_attributes) do
    payment_attributes.merge(cf_checkout_error_code: error_code)
  end
  let(:error_code) { order.payments.collect(&:error_code).join '-' }

  before do
    Timecop.freeze(Time.now)
  end

  describe '#success' do
    context 'for payment_success event' do
      event_name = "payment_success"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        context 'when order is subscription' do
          let(:order) { create(:order_with_pagarme_subscription, user: user) }

          before do
            expect_client_receive('assinatura-ativada', subscription_attributes)
          end

          it 'creates rdstation payment_success event' do
            subject.send_event
          end
        end

        context 'when checkout method is bank_slip' do
          let(:order) { create(:order, user: user) }

          before do
            expect_client_receive('pagamento-aprovado-pacote-boleto',
                                  payment_attributes_success)
          end

          it 'creates rdstation payment_success event' do
            subject.send_event
          end
        end

        context 'when checkout method is checkout_method' do
          let(:order) { create(:order_credit_card, user: user) }

          before do
            expect_client_receive('pagamento-aprovado-pacote-cartao',
                                  payment_attributes_success)
          end

          it 'creates rdstation payment_success event' do
            subject.send_event
          end
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        context 'when order is subscription' do
          let(:order) { create(:order_with_pagarme_subscription, user: user) }

          before do
            expect_client_receive('assinatura-ativada', subscription_attributes)
          end

          it 'creates rdstation payment_success event' do
            subject.success
          end
        end

        context 'when checkout method is bank_slip' do
          let(:order) { create(:order, user: user) }

          before do
            expect_client_receive('pagamento-aprovado-pacote-boleto',
                                  payment_attributes_success)
          end

          it 'creates rdstation payment_success event' do
            subject.success
          end
        end

        context 'when checkout method is checkout_method' do
          let(:order) { create(:order_credit_card, user: user) }

          before do
            expect_client_receive('pagamento-aprovado-pacote-cartao',
                                  payment_attributes_success)
          end

          it 'creates rdstation payment_success event' do
            subject.success
          end
        end
      end
    end
  end

  describe '#refused' do
    context 'for payment_refused event' do
      event_name = "payment_refused"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }

        before do
          expect_client_receive('pagamento-recusado', refused_attributes)
        end

        it 'creates rdstation payment_refused event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        let(:order) { create(:order_with_pagarme_subscription, user: user) }

        before do
          expect_client_receive('pagamento-recusado', refused_attributes)
        end

        it 'creates rdstation payment_refused event' do
          subject.refused
        end
      end
    end
  end

  describe '#bank_slip' do
    context 'for payment_bank_slip event' do
      event_name = "payment_bank_slip_generated"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-gerado', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-gerado', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.bank_slip_generated
        end
      end
    end
  end

  describe '#bank_slip_expires_today' do
    context 'for payment_bank_slip event' do
      event_name = "payment_bank_slip_expires_today"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-vence-hoje', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-vence-hoje', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.bank_slip_expires_today
        end
      end
    end
  end

  describe '#bank_slip_expired' do
    context 'for payment_bank_slip event' do
      event_name = "payment_bank_slip_expired"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-vencido', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:bank_slip_attributes) do
          default_attributes.merge(
            cf_boleto_valor: order.price_paid.to_f.to_s,
            cf_boleto_data_expiracao: (order.created_at + 1.day).to_s,
            cf_boleto_codigo: "1234 5678",
            cf_boleto_link: "https://pagar.me"
          )
        end

        before do
          expect_client_receive('payment_wpp-boleto-vencido', bank_slip_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.bank_slip_expired
        end
      end
    end
  end

  describe '#card_error' do
    context 'for payment_bank_slip event' do
      event_name = "payment_card_error"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:card_attributes) do
          default_attributes.merge(
            wpp_cartao_link: order.package.slug
          )
        end

        before do
          expect_client_receive('payment_wpp-cartao-erro', card_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.send_event
        end
      end
      context 'direct from payment class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Payment.new({ order: order })
        end
        let(:order) do
          create(:order, user: user, payments: [create(:payment, :bank_slip)])
        end
        let(:card_attributes) do
          default_attributes.merge(
            wpp_cartao_link: order.package.slug
          )
        end

        before do
          expect_client_receive('payment_wpp-cartao-erro', card_attributes)
        end

        it 'creates rdstation payment_bank_slip event' do
          subject.card_error
        end
      end
    end
  end

  def expect_client_receive(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: event_name,
              payload: attributes }).and_return(client)
    expect(client).to receive(:create)
  end
end
