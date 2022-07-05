class AddsCanonicalUriToMedia < ActiveRecord::Migration[4.2]
  def change
    Permalink.connection.execute('
      UPDATE permalinks set canonical_uri = canonical_refs.slug
      FROM (
        SELECT medium_id, slug FROM permalinks
          WHERE medium_id IS NOT NULL
          AND slug LIKE \'enem-e-vestibulares/materias%\'
      ) canonical_refs
      WHERE permalinks.medium_id = canonical_refs.medium_id
        AND permalinks.canonical_uri IS NULL
        AND permalinks.slug LIKE \'enem-e-vestibulares%\'
    ')
  end
end
