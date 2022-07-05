# frozen_string_literal: true

class SynchronizeIntercomUsersWorker < BaseIntercomUserWorker
  def perform(users, process_description)
    @log_messages = MeSalva::Logs::Message.new(process_description)
    users.each do |user|
      user_id = user['user_id']
      premium_status = user['premium_status']

      # rubocop:disable Layout/LineLength
      begin
        intercom_action('update', user_id, 'User', subscriber: premium_status)
        @log_messages.save("synchronize_intercom_users: { user_id: #{user_id}, premium_status: #{premium_status} } ", 'Success')
      rescue StandardError
        @log_messages.save("synchronize_intercom_users: { user_id: #{user_id}, premium_status: #{premium_status} } ", 'Error')
      end
      # rubocop:enable Layout/LineLength
      sleep 0.1
    end
  end
end
