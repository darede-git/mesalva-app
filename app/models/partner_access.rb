# frozen_string_literal: true

class PartnerAccess < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :cpf, :birth_date, :partner
end
