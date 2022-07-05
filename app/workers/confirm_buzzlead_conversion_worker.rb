# frozen_string_literal: true

class ConfirmBuzzleadConversionWorker
  include Sidekiq::Worker

  def perform
    ::Order.buzzlead_expired.each do |order|
      begin
        MeSalva::Campaign::Buzzlead::Convert.new(order).confirm
      rescue MeSalva::Error::BuzzleadApiConnectionError => exception
        NewRelic::Agent.notice_error(exception,
                                     response_body: exception.body,
                                     status_code: exception.status_code)
      end
    end
  end
end
