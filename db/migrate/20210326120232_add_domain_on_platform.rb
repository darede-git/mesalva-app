class AddDomainOnPlatform < ActiveRecord::Migration[5.2]
  def change
    add_column :platforms, :domain, :string, nullable: false
  end
end
