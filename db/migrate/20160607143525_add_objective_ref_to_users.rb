class AddObjectiveRefToUsers < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :objective, index: true, foreign_key: true
  end
end
