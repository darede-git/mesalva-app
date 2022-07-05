# frozen_string_literal: true

require 'spec_helper'

describe MeSalva::Crm::Rdstation::Event::PrepTest do
  let(:submission_token) do
    Base64.encode64(Time.now.strftime(t('time.formats.date'))).delete("\n").delete("=")
  end
  let(:node_module) { create(:node_module) }
  let(:item) { create(:item) }
  let(:default_attributes) do
    { cf_submission_token: submission_token,
      cf_node_module_name: node_module.name,
      cf_item_name: item.name }
  end

  describe '#preptest' do
    context 'for prep_test_answer event' do
      event_name = "prep_test_answer"
      context 'through sender class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::Sender.new(event: event_name.to_sym,
                                                     params: { user: user,
                                                               node_module: node_module,
                                                               item: item,
                                                               submission_token: submission_token })
        end
        before do
          expect_prep_test_answer_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation prep_test_answer event' do
          subject.send_event
        end
      end
      context 'direct from preptest class' do
        let(:subject) do
          MeSalva::Crm::Rdstation::Event::PrepTest.new({ user: user,
                                                         node_module: node_module,
                                                         item: item,
                                                         submission_token: submission_token })
        end
        before do
          expect_prep_test_answer_in_rd(event_name, default_attributes)
        end

        it 'creates rdstation prep_test_answer event' do
          subject.answer
        end
      end
    end
  end

  def expect_prep_test_answer_in_rd(event_name, attributes)
    client = double
    expect(MeSalva::Crm::Rdstation::Event::Client).to receive(:new)
      .with({ user: user,
              event_name: "#{event_name}|#{node_module.slug}",
              payload: attributes })
      .and_return(client)
    expect(client).to receive(:create)
  end
end
