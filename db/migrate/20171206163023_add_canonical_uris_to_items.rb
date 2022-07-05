class AddCanonicalUrisToItems < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute('
    UPDATE permalinks set canonical_uri = canonical_refs.slug
      FROM (
          SELECT item_id, slug FROM permalinks
            WHERE medium_id IS NULL
            AND item_id IS NOT NULL
            AND slug LIKE \'enem-e-vestibulares/materias%\'
      ) canonical_refs
    WHERE permalinks.item_id = canonical_refs.item_id
      AND permalinks.canonical_uri IS NULL
      AND permalinks.medium_id IS  NULL
      AND permalinks.slug LIKE \'enem-e-vestibulares%\'
    ')
  end
end
