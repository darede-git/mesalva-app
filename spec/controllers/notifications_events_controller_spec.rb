# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationEventsController, type: :controller do
  before { user_session }
  let(:notification) { create(:notification, user_id: user.id) }

  context 'as an user' do
    context '#create' do
      it 'should make a new notification event' do
        expect do
          post :create, params: { notification_id: notification.id,
                                  read: true }
        end.to change(NotificationEvent, :count).by(1)
      end
    end
  end
  context 'as an admin' do
    before { authentication_headers_for(admin) }
    let(:notification_event) do
      create(:notification_event,
             user_id: user.id,
             notification: notification)
    end
    context '#update' do
      it 'should modify existing notification_event to not read' do
        put :update, params: { user_uid: user.uid,
                               id: notification_event.id,
                               read: false }
        notification_event.reload
        expect(notification_event.read).to be(false)
      end
    end
    context '#destroy' do
      it 'should destroy existing notification_event' do
        delete :destroy, params: { id: notification_event.id }
        expect { NotificationEvent.find(notification_event.id) }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
