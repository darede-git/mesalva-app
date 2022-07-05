class CreateVotes < ActiveRecord::Migration[4.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :voter, polymorphic: true, index: true
      t.boolean :like, null: false

      t.timestamps null: false
    end
  end
end
