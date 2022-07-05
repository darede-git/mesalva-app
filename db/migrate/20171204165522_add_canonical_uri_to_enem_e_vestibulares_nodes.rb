class AddCanonicalUriToEnemEVestibularesNodes < ActiveRecord::Migration[4.2]
  def change

    enem_nodes_permalinks = Permalink.where("slug ILIKE ?", "enem-e-vestibulares%").node_permalinks
    enem_library_nodes_permalinks = enem_nodes_permalinks.select do |np|
      np.slug.start_with? 'enem-e-vestibulares/materias'
    end

    enem_library_nodes_permalinks.each do |p|
      node_slug = p.slug.split('/').last
      enem_nodes_to_canonize = enem_nodes_permalinks.where("slug LIKE ?", "%#{node_slug}")
      enem_nodes_to_canonize.update_all(canonical_uri: p.slug)
    end

  end
end
