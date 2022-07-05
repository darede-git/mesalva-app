class ChangeColumnInMedia < ActiveRecord::Migration[4.2]
  def change
    change_column :media, :seconds_duration, :integer
  end
end
