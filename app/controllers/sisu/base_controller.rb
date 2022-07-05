# frozen_string_literal: true

class Sisu::BaseController < ApplicationController
  private

  def course
    description_alternative(params[:course])
  end

  def state_initials
    state&.split(' - ')&.last
  end

  def state
    description_alternative(params[:state])
  end

  def modality
    description_alternative(params[:modality])
  end

  def description_alternative(id)
    Quiz::Alternative.find(id).try(:description) if id
  end
end
