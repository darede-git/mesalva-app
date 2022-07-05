class AddPrivateClassCreditsToAccessesAndPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :private_class_credits, :integer, null: true, default: 0
    add_column :accesses, :private_class_credits, :integer, null: true, default: 0
  end
end
