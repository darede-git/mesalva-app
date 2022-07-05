class CreateBookshopGiftPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :bookshop_gift_packages do |t|
      t.boolean :active
      t.string :bookshop_link
      t.references :package, foreing_key: true
      t.date :notified_at

      t.timestamps
    end
  end
end