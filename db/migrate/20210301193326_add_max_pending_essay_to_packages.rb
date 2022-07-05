class AddMaxPendingEssayToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :max_pending_essay, :integer, default: 2
  end
end
