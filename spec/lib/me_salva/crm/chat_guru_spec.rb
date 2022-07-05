# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeSalva::Crm::ChatGuru do
  include PermissionHelper
  context 'Com usuário sem telefone' do
    let!(:user1) { create(:user) }
    before { grant_context_permission('chat_guru', 'receive_message', user) }
    subject { described_class.new(user1) }
    it 'chamando a lib chat_guru' do
      expect { subject.send_message('ola, posso ajudar?') }
        .to raise_error("Usuário sem telefone cadastrado")
    end
  end

  context 'Com usuário com telefone' do
    let!(:user) do
      create(:user, phone_area: '51',
                    phone_number: '999999999')
    end
    before { grant_context_permission('chat_guru', 'receive_message', user) }
    subject { described_class.new(user) }

    ENV['CHATGURU_KEY'] = 'a'
    ENV['CHATGURU_ACCOUNT_ID'] = 'b'
    ENV['CHATGURU_PHONE_ID'] = 'c'

    it 'chamando a lib chat_guru' do
      date = '2022-04-05 11:12'
      text_message = 'ola, posso ajudar?'
      params = {
        action: 'chat_add',
        text: text_message,
        send_date: date,
        key: ENV['CHATGURU_KEY'],
        account_id: ENV['CHATGURU_ACCOUNT_ID'],
        phone_id: ENV['CHATGURU_PHONE_ID'],
        chat_number: "55#{user.phone_area}#{user.phone_number}",
        name: "auto-#{user.uid}"
      }
      allow(HTTParty).to receive(:post)
        .with("https://s14.chatguru.app/api/v1?#{params.to_query}")
        .and_return({
                      "chat_add_id": "624af987d5147ccf9c2e34df",
                      "chat_add_status": "pending",
                      "code": 201,
                      "description": "Chat cadastrado para inclusão com sucesso!",
                      "result": "success"
                    })
      response = subject.send_message(text_message, date)
      expect(response[:chat_add_id]).to eq('624af987d5147ccf9c2e34df')
    end
  end
end
