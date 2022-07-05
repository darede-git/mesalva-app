class AddCreditsToAccessesAndPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :accesses, :essay_credits, :integer
    add_column :packages, :essay_credits, :integer
    add_column :packages, :unlimited_essay_credits, :boolean
  end
end
