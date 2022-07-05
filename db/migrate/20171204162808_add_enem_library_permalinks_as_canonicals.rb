class AddEnemLibraryPermalinksAsCanonicals < ActiveRecord::Migration[4.2]
  def change
    enem_library = Permalink.where("slug ILIKE ?", "enem-e-vestibulares/materias%")
    enem_library.each do |perm|
      CanonicalUri.create(slug: perm.slug)
    end
  end
end
