class AddModulesCanonicalUris < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute('
    UPDATE permalinks SET canonical_uri = canonical_refs.slug
    FROM (
      SELECT node_module_id, slug from permalinks
        WHERE node_module_id IS NOT NULL
        AND item_id IS NULL
        AND slug LIKE \'enem-e-vestibulares/materias%\'
    ) canonical_refs
    WHERE permalinks.node_module_id = canonical_refs.node_module_id
      AND permalinks.canonical_uri IS NULL
      AND permalinks.item_id IS NULL
      AND permalinks.slug LIKE \'enem-e-vestibulares%\'')
  end
end
