# frozen_string_literal: true

class CreatePartnerAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :partner_accesses do |t|
      t.string :cpf
      t.date :birth_date
      t.string :partner
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
