# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatGuruWorker do
  let!(:user) { create(:user, phone_area: '51', phone_number: '999999999') }

  describe '#perform' do
    ENV['CHATGURU_KEY'] = 'a'
    ENV['CHATGURU_ACCOUNT_ID'] = 'b'
    ENV['CHATGURU_PHONE_ID'] = 'c'

    it 'chat_guru perfom in' do
      date = '2022-04-05 11:12'
      text_message = t("crm.chat_guru.message_unfinished_checkout")
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

      subject.perform(user.uid, date)
    end
  end
end
