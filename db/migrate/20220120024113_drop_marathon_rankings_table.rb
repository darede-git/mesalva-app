class DropMarathonRankingsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :marathon_rankings
  end
end
