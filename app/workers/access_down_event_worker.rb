# frozen_string_literal: true

class AccessDownEventWorker
  include Sidekiq::Worker
  include IntercomHelper
  include UtmHelper
  include CrmEvents

  def perform
    Access.active.expires_today.each do |access|
      if downgrade?(access.user)
        update_intercom_user(access.user, subscriber: User::PREMIUM_STATUS[:ex_subscriber],
                                          plan: '')
        return create_crm('account_downgrade', access.user)
      end
      update_intercom_user(access.user, plan: access.actives_package_slug)
      create_crm('account_downsell', access.user)
    end
  end

  def downgrade?(user)
    Access.by_user_active_in_range(user).count <= 1
  end
end
