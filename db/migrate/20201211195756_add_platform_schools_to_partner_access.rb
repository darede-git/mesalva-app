# frozen_string_literal: true

class AddPlatformSchoolsToPartnerAccess < ActiveRecord::Migration[5.2]
  def change
    add_reference :partner_accesses, :platform_schools, foreign_key: true
  end
end
