class AddColumnAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :address_type, :string, default: 'billing'
  end
end
