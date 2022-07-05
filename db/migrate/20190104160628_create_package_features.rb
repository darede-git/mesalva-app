class CreatePackageFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :package_features do |t|
      t.references :package, foreign_key: true, index: true
      t.references :feature, foreign_key: true, index: true

      t.timestamps
    end
  end
end
