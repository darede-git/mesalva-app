# frozen_string_literal: true

require 'intercom'
require 'me_salva/crm/client'
require 'active_support/core_ext/enumerable'

module MeSalva
  module Crm
    class Synchronization
      include MeSalva::Crm
      include CrmEventsParamsHelper

      def initialize(start_date, finish_date, process_description)
        @start_date = start_date.to_date
        @finish_date = finish_date.to_date
        @process_description = process_description
        @log_statistics =
          MeSalva::Logs::Statistic.new(MeSalva::Logs::Objects::Intercom.synchronization,
                                       @process_description)
        @log_messages = MeSalva::Logs::Message.new(@process_description)
      end

      def update_user_status
        @log_messages.save('update loop is about to start')
        find_users
        @worker_users = []
        @users.each do |user|
          @user = user
          set_user_status
        end
        SynchronizeIntercomUsersWorker.perform_async(@worker_users, @process_description)
        @log_messages.save('update loop has ended')
      end

      private

      def find_users
        @users = ::User.find(user_list)
      end

      def user_list
        orders = Order.where("DATE(created_at) BETWEEN ? AND ?", @start_date, @finish_date)
        orders.map { |order| order.user.id }.uniq!
      end

      def student_type
        MeSalva::User::PremiumStatusValidator.new(@user).intercom_status
      end

      def set_user_status
        if student_type.present?
          @user.update(premium_status: student_type)
          @worker_users << { user_id: @user.id, premium_status: @user.premium_status }
        else
          @log_messages.save("User without student type user_id: #{@user.id}", 'Error')
        end
      end
    end
  end
end
