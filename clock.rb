# frozen_string_literal: true

require './config/boot'
require './config/environment'
require 'clockwork'
require 'sidekiq'
require 'me_salva/postgres/materialized_views'
require 'me_salva/payment/iugu/order'

module Clockwork
  configure do |config|
    config[:sleep_timeout] = 4
    config[:tz] = 'America/Sao_Paulo'
  end

  every(1.day, 'expired_subscriptions.job', at: '06:41') do
    ExpiredSubscriptionsWorker.perform_async
  end

  every(1.day, 'pending_subscriptions.job', at: '07:41') do
    PendingSubscriptionsWorker.perform_async
  end

  every(1.day, 'que_curso_sisu_leads.job', at: '03:00') do
    SisuQueCursoLeadsWorker.perform_async
  end

  every(1.day, 'pending_subscriptions.job', at: '05:41') do
    RenewPlayStoreSubscriptionsWorker.perform_async
  end

  every(1.day, 'access_down_event.job', at: '06:00') do
    AccessDownEventWorker.perform_async
  end

  every(6.hours, 'create_bookshop_coupon.job') do
    BookshopGiftCreateCouponWorker.perform_async
  end

  every(6.hours, 'grant_bookshop_coupon.job') do
    BookshopGiftGrantCouponWorker.perform_async
  end

  every(1.day, 'post_buy_notification_campaign.job', at: '05:05') do
    PostBuyNotificationCampaignWorker.perform_async
  end

  every(1.day, 'pending_essay_event.job', at: '06:01') do
    PendingEssayEventWorker.perform_async
  end

  every(5.minutes, 'pending_one_shots_credit_card.job') do
    OneshotCreditCardSubscriptionsWorker.perform_async
  end

  every(5.minutes, 'instructors_mass_gift.job') do
    InstructorUsersWorker.perform_async
  end

  every(1.hour, 'pending_one_shots_bank_slip.job') do
    OneshotBankSlipSubscriptionsWorker.perform_async
  end

  every(1.hour, 'correct_not_found_orders.job') do
    MeSalva::Payment::Iugu::Order.reprocess
  end

  every(1.week, 'study_plan_structure_update.job', at: 'Monday 03:02') do
    StudyPlanStructureUpdateWorker.perform_async
  end

  every(1.month, 'difficulty_calculator.job', at: 'Monday 06:02') do
    DifficultyCalculatorWorker.perform_async
  end

  every(2.hour, 'expired_essay_submission.job') do
    ExpiredEssaySubmissionWorker.perform_async
  end

  every(1.day, 'refresh_materialized_views.job', at: '03:00') do
    MeSalva::Postgres::MaterializedViews.new.refresh
  end

  every(1.day, 'remove_old_events.job', at: '04:00') do
    MeSalva::Postgres::PermalinkEvents.new.remove
  end

  every(1.day, 'confirm_buzzlead_conversion.job', at: '08:00') do
    ConfirmBuzzleadConversionWorker.perform_async
  end

  every(1.day, 'inactivate_expired_accesses.job', at: '04:00') do
    InactivateExpiredAccessesWorker.perform_async
  end

  every(1.day, 'event_expired_accesses.job', at: '06:00') do
    AccessExpiresEventWorker.perform_async
  end
end
