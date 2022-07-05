# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:other_user) { create(:user) }
  let(:default_serializer) { V2::NotificationSerializer }

  context 'created notification' do
    before { user_session }
    let!(:older_notification) do
      create(:notification, user_id: user.id)
    end
    let!(:expired_notification) do
      create(:notification, :expired, user_id: user.id)
    end
    let!(:newer_notification) do
      create(:notification, user_id: user.id)
    end
    let!(:other_user_notification) do
      create(:notification, user_id: other_user.id)
    end

    context 'as an user' do
      it 'shows index correctly without expired and other_user\'s' do
        get :index
        assert_apiv2_response(:ok,
                              [newer_notification, older_notification],
                              default_serializer,
                              %i[notification_events])
      end
    end
    context 'as an admin with user param' do
      before { authentication_headers_for(admin) }
      it 'shows all user\'s notifications' do
        get :index, params: { user_uid: user.uid }
        assert_apiv2_response(:ok,
                              [newer_notification,
                               expired_notification,
                               older_notification],
                              default_serializer,
                              %i[notification_events])
      end

      it 'show individual notifications with #show' do
        get :show, params: { id: newer_notification.id }
        assert_apiv2_response(:ok,
                              newer_notification,
                              default_serializer,
                              %i[notification_events])
      end

      it 'delete individual notifications' do
        delete :destroy, params: { id: newer_notification.id }
        expect { Notification.find(newer_notification.id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'delete individual notifications' do
        delete :destroy, params: { id: newer_notification.id }
        expect { Notification.find(newer_notification.id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with global notifications' do
      let!(:global_user_notification) do
        create(:notification, user_id: nil)
      end
      let!(:read_global_user_notification) do
        create(:notification, user_id: nil)
      end

      before do
        create(:notification_event,
               user_id: user.id,
               notification: read_global_user_notification)
      end

      it 'shows global notifications' do
        get :index, params: { page: 1, per_page: 3 }
        assert_apiv2_response(:ok,
                              [read_global_user_notification,
                               global_user_notification,
                               newer_notification],
                              default_serializer,
                              %i[notification_events])
      end
    end
  end
  context 'created many notifications' do
    before { user_session }
    let!(:five_notifications) do
      create_list(:notification, 5, user_id: user.id)
    end
    let!(:two_notifications) do
      create_list(:notification, 2, user_id: user.id)
    end
    let!(:five_expired_notifications) do
      create_list(:notification, 5, :expired, user_id: user.id)
    end
    let!(:two_more_notifications) do
      create_list(:notification, 2, user_id: user.id)
    end

    it 'paginates first page correctly' do
      get :index, params: { page: 1, per_page: 3 }
      assert_apiv2_response(:ok,
                            [two_more_notifications.reverse,
                             two_notifications.reverse.first].flatten,
                            default_serializer,
                            %i[notification_events])
    end
    it 'paginates second page correctly' do
      get :index, params: { page: 2, per_page: 3 }
      assert_apiv2_response(:ok,
                            [two_notifications.first,
                             five_notifications.reverse[0..1]].flatten,
                            default_serializer,
                            %i[notification_events])
    end
  end
end
