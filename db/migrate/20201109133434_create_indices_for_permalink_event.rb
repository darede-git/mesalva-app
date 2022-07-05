class CreateIndicesForPermalinkEvent < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      CREATE INDEX permalink_events_user_id_idx on permalink_events (user_id);
      CREATE INDEX permalink_events_user_id_permalink_slug_idx ON permalink_events (user_id, permalink_slug);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX permalink_events_user_id_idx;
      DROP INDEX permalink_events_user_id_permalink_slug_idx;
    SQL
  end
end
