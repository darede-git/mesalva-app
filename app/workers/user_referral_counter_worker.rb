# frozen_string_literal: true

class UserReferralCounterWorker
  include Sidekiq::Worker

  def perform(token)
    user_referral = UserReferral.find_by_user_id(User.find_by_token(token).id)
    user_referral.update(confirmed_referrals: count(token))
    user_referral.update(being_processed: false)
  end

  private

  def count(token)
    ActiveRecord::Base.connection.execute(query(token)).first['count']
  end

  def query(token)
    <<~SQL
      SELECT COUNT (*)
      FROM utms
      INNER JOIN crm_events ON crm_events.id = utms.referenceable_id
      WHERE utms.utm_source = 'indicacao-desafio'
      AND utms.utm_medium = 'link_pessoal'
      AND utms.utm_content = \'#{token}\'
      AND utms.utm_campaign = 'desafio-enem-do-zero'
      AND utms.referenceable_type = 'CrmEvent'
      AND utms.id > 13600000
      AND crm_events.event_name = 'sign_up'
    SQL
  end
end
