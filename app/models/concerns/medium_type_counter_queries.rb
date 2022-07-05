# frozen_string_literal: true

module MediumTypeCounterQueries
  def self.included(base)
    base.extend(MediumTypeCounterQueries)
  end

  # rubocop:disable Metrics/MethodLength
  def node_module_medium_type_counters_query
    "
SELECT
node_module_id as id,
json_object(array_agg(array [ medium_type, count::VARCHAR ])) as counters
FROM
(
  SELECT
    nm.id AS node_module_id,
    count(DISTINCT m.id) AS count,
    m.medium_type
  FROM
    node_modules nm
    INNER JOIN node_module_items nmi ON nmi.node_module_id = nm.id
    INNER JOIN items i ON i.id = nmi.item_id AND i.active = TRUE
    INNER JOIN item_media im ON im.item_id = nmi.item_id
    INNER JOIN media m ON m.id = im.medium_id AND m.active = TRUE
  WHERE
    nm.active = TRUE AND nm.id IN (:node_module_ids)
  GROUP BY
    nm.id, m.medium_type
  ORDER BY
    nm.id, m.medium_type
) a
GROUP BY
node_module_id"
  end

  def item_medium_type_counters_query
    "SELECT item_id AS id,
            json_object(array_agg(array [ medium_type, count::VARCHAR ])) AS counters
    FROM
      ( SELECT i.id AS item_id,
               count(DISTINCT m.id) AS COUNT,
               m.medium_type
       FROM items i
       INNER JOIN item_media im ON im.item_id = i.id
       INNER JOIN media m ON m.id = im.medium_id
       AND m.active = TRUE
       WHERE i.active = TRUE
         AND i.id IN (:item_ids)
       GROUP BY i.id,
                m.medium_type
       ORDER BY i.id,
                m.medium_type ) a
    GROUP BY item_id"
  end
  # rubocop:enable Metrics/MethodLength
end
