class ChangeAccessActiveDefaultValue < ActiveRecord::Migration[4.2]
  def change
    change_column_default :users, :active, true
  end
end
