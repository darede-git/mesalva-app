# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :set_revenue_cat

  def revoke_subscription
    response = @revenue_cat.revoke_subscription(params['product'])
    render_ok(response[:body]) if response[:ok]
  end

  private

  def set_revenue_cat
    @revenue_cat = MeSalva::Payment::Revenuecat::Subscriber.new(params['app_user_id'])
  end
end
