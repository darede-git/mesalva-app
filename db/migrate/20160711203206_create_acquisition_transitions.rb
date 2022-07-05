class CreateAcquisitionTransitions < ActiveRecord::Migration[4.2]
  def change
    create_table :acquisition_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :acquisition_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_index(:acquisition_transitions,
              [:acquisition_id, :sort_key],
              unique: true,
              name: "index_acquisition_transitions_parent_sort")
    add_index(:acquisition_transitions,
              [:acquisition_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_acquisition_transitions_parent_most_recent")
  end
end
