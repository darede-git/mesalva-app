class CreateEssaySubmissionTransitions < ActiveRecord::Migration[4.2]
  def change
    create_table :essay_submission_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata, default: "{}"
      t.integer :sort_key, null: false
      t.integer :essay_submission_id, null: false
      t.boolean :most_recent, null: false
      t.timestamps null: false
    end

    add_index(:essay_submission_transitions,
              [:essay_submission_id, :sort_key],
              unique: true,
              name: "index_essay_submission_transitions_parent_sort")
    add_index(:essay_submission_transitions,
              [:essay_submission_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_essay_submission_transitions_parent_most_recent")
  end
end
