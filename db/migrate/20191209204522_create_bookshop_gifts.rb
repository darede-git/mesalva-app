class CreateBookshopGifts < ActiveRecord::Migration[5.2]
  def change
    create_table :bookshop_gifts do |t|
      t.string :coupon
      t.references :order, foreign_key: true
      t.references :bookshop_gift_package, foreign_key: true
      t.boolean :coupon_available, default: false

      t.timestamps
    end
  end
end
