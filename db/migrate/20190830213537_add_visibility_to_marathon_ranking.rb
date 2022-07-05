class AddVisibilityToMarathonRanking < ActiveRecord::Migration[5.2]
  def change
    add_column :marathon_rankings, :visibility, :string
  end
end
