# frozen_string_literal: true

class PartnerAccessesController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_partner_access

  def register
    if @partner_access.update(user_id: current_user.id)
      head :ok
    else
      render_unprocessable_entity(@partner_access.errors)
    end
  end

  private

  def set_partner_access
    params.permit(:cpf, :birth_date)

    @partner_access = PartnerAccess.where(
      cpf: params['cpf'],
      birth_date: params['birth_date']
    ).first

    return render_not_found unless @partner_access
    return render_unauthorized unless @partner_access.user_id.nil?
  end
end
