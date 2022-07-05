class CorrectsCommentsPolymofism < ActiveRecord::Migration[4.2]
  def change
    rename_column :comments, :commentable_type, :commenter_type
    rename_column :comments, :commentable_id, :commenter_id
    change_table :comments do |t|
      t.references :commentable, polymorphic: true
    end

    execute <<-SQL
      UPDATE comments c
      SET commentable_type = subquery.type
        FROM
          (SELECT id,
                  CASE
                    WHEN medium_id IS NOT NULL THEN 'Medium'
                    WHEN essay_submission_id IS NOT NULL THEN 'EssaySubmission'
                    WHEN user_id IS NOT NULL THEN 'User'
                    ELSE NULL
                  END as type
            FROM comments
          ) AS subquery
        WHERE c.id = subquery.id;

      UPDATE comments c
        SET commentable_id = subquery.commentable_id
      FROM
        (SELECT id,
                COALESCE(medium_id, essay_submission_id, user_id) commentable_id
          FROM comments
        ) AS subquery
      WHERE c.id = subquery.id;
    SQL

    remove_column :comments, :medium_id
    remove_column :comments, :essay_submission_id
    remove_column :comments, :user_id
  end
end
