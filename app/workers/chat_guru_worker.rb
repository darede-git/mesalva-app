# frozen_string_literal: true

class ChatGuruWorker
  include Sidekiq::Worker

  def perform(uid, date = nil)
    @user = User.find_by_uid(uid)

    return nil if has_paid_order_today? || already_sent_message_today?

    begin
      chat = MeSalva::Crm::ChatGuru.new(@user)
      chat.send_message(I18n.t("crm.chat_guru.message_unfinished_checkout"), date)
      UserSetting.find_or_create(user: @user, key: 'chat_guru').update(value: {sent_at: Date.today.to_s})
    rescue
      # Ignored
    end
  end

  private

  def has_paid_order_today?
    Order.where(user_id: @user.id, status: 2)
      .where('created_at > ?', DateTime.now - 1.day).count
      .positive?
  end

  def already_sent_message_today?
    chat_guru = UserSetting.where(user: @user, key: 'chat_guru').first

    return false if chat_guru.nil?

    chat_guru.value['sent_at'] == Date.today.to_s
  end
end
