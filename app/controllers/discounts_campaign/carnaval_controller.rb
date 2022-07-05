# frozen_string_literal: true

require 'me_salva/campaign/carnaval/discount_generator'

class DiscountsCampaign::CarnavalController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def create
    render_created(discount)
  end

  private

  def discount
    carnaval_discount_generator.build
  end

  def carnaval_discount_generator
    @carnaval_discount_builder ||= client.new(current_user.id)
  end

  def client
    MeSalva::Campaign::Carnaval::DiscountGenerator
  end
end
