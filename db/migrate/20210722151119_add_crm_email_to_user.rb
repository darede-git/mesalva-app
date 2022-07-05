# frozen_string_literal: true

class AddCrmEmailToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :crm_email, :string
  end
end
