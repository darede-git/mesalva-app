class AddsPackageSlugFaqs < ActiveRecord::Migration[4.2]
  def change
  	add_column :faqs, :package_slug, :string
  end
end
