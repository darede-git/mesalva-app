class AddEssayEventUserUidColumn < ActiveRecord::Migration[4.2]
  def change
  	add_column :essay_events, :user_uid, :string
  	execute <<-SQL
      UPDATE essay_events es
      SET user_uid = subquery.uid
        FROM
          (SELECT id, uid
            FROM users u
          ) AS subquery
        WHERE es.user_id = subquery.id;
    SQL
  end
end
