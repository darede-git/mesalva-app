class AddMaterializedViewForNodeSecondsDuration < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute("
    CREATE MATERIALIZED VIEW vw_node_seconds_duration as
      SELECT
        no.id AS node_id,
        sum(seconds_duration) AS seconds_duration
      FROM
        nodes no
        INNER JOIN nodes n ON n.id = no.id OR 
          n.ancestry ilike no.ancestry || '/' || no.id || '/%' OR
          n.ancestry = no.ancestry || '/' || no.id OR 
          n.ancestry ilike no.id::varchar || '/%' OR
          n.ancestry = no.id::varchar
        INNER JOIN node_node_modules nnm ON nnm.node_id = n.id
        INNER JOIN node_modules nm ON nm.id = nnm.node_module_id AND nm.active = TRUE
        INNER JOIN node_module_items nmi ON nmi.node_module_id = nnm.node_module_id
        INNER JOIN items i ON i.id = nmi.item_id AND i.active = TRUE
        INNER JOIN item_media im ON im.item_id = nmi.item_id
        INNER JOIN media m ON m.id = im.medium_id AND m.medium_type = 'video' AND m.active = TRUE
      WHERE
        no.active = TRUE
      GROUP BY
        no.id
      ORDER BY
        no.id")
  end
end
