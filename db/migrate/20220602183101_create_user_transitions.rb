class CreateUserTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :user_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_index(:user_transitions,
              [:user_id, :sort_key],
              unique: true,
              name: "index_user_transitions_parent_sort")
    add_index(:user_transitions,
              [:user_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_user_transitions_parent_most_recent")
  end
end
