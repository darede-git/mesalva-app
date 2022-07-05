# frozen_string_literal: true

class AddRoleToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :role, :string
  end
end
