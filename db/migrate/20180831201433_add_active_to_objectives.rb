class AddActiveToObjectives < ActiveRecord::Migration[4.2]
  def change
    add_column :objectives, :active, :boolean, default: true, null: false
  end
end
