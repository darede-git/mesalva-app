# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::Subscription do
  let(:default_attributes) do
    {
      cf_nome_do_produto: order.package_name,
      cf_motivo_do_cancelamento_assinatura: 'Entrei de férias',
      cf_grau_de_satisfacao_cancelamento: '6'
    }
  end

  let(:default_attributes_no_quiz) do
    { cf_nome_do_produto: order.package_name }
  end

  before do
    Timecop.freeze(Time.now)
  end

  describe '#unsubscribe' do
    context 'for subscription_unsubscribe event' do
      event_name = "subscription_unsubscribe"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { subscription: subscription })
        end
        context 'with quiz' do
          before do
            expect_subscription_cancel_in_rd(default_attributes)
          end
          let(:subscription) { create(:subscription, user: user) }
          let(:cancellation_quiz) do
            create(:cancellation_quiz,
                   quiz: { 'question1.answer' => 'Entrei de férias',
                           'question2.answer' => '6' })
          end
          let!(:order) do
            create(:order,
                   subscription: subscription,
                   cancellation_quiz: cancellation_quiz)
          end

          it 'creates rdstation subscription_unsubscribe event' do
            subject.send_event
          end
        end

        context 'without quiz' do
          before do
            expect_subscription_cancel_in_rd(default_attributes_no_quiz)
          end

          let(:subscription) { create(:subscription, user: user) }
          let!(:order) do
            create(:order, subscription: subscription)
          end

          it 'creates rdstation subscription_unsubscribe event' do
            subject.send_event
          end
        end
      end
      context 'direct from subscription class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Subscription.new({ subscription: subscription })
        end
        context 'with quiz' do
          before do
            expect_subscription_cancel_in_rd(default_attributes)
          end
          let(:subscription) { create(:subscription, user: user) }
          let(:cancellation_quiz) do
            create(:cancellation_quiz,
                   quiz: { 'question1.answer' => 'Entrei de férias',
                           'question2.answer' => '6' })
          end
          let!(:order) do
            create(:order,
                   subscription: subscription,
                   cancellation_quiz: cancellation_quiz)
          end

          it 'creates rdstation subscription_unsubscribe event' do
            subject.unsubscribe
          end
        end

        context 'without quiz' do
          before do
            expect_subscription_cancel_in_rd(default_attributes_no_quiz)
          end

          let(:subscription) { create(:subscription, user: user) }
          let!(:order) do
            create(:order, subscription: subscription)
          end

          it 'creates rdstation subscription_unsubscribe event' do
            subject.unsubscribe
          end
        end
      end
    end
  end

  def expect_subscription_cancel_in_rd(attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: 'assinatura-cancelada-pelo-usuario',
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end
