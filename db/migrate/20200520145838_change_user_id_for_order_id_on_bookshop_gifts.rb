class ChangeUserIdForOrderIdOnBookshopGifts < ActiveRecord::Migration[5.2]
  def up
    add_column :bookshop_gifts, :order_id, :bigint, foreign_key: true

    execute <<-SQL
      WITH bg AS (
        SELECT bookshop_gifts.id as bookshop_gift_id, orders.id as order_id
        FROM bookshop_gifts
        INNER JOIN orders ON orders.user_id = bookshop_gifts.user_id
        INNER JOIN bookshop_gift_packages ON bookshop_gift_packages.package_id = orders.package_id
        WHERE orders.status = 2
        AND bookshop_gifts.user_id IS NOT NULL
      )
      UPDATE bookshop_gifts
      SET order_id = bg.order_id
      FROM bg
      WHERE bookshop_gifts.id = bg.bookshop_gift_id
    SQL

    remove_column :bookshop_gifts, :user_id, :bigint, foreign_key: true
  end

  def down
    add_column :bookshop_gifts, :user_id, :bigint, foreign_key: true

    execute <<-SQL
      WITH bg AS (
        SELECT bookshop_gifts.id as bookshop_gift_id, orders.user_id as user_id
        FROM bookshop_gifts
        INNER JOIN orders ON orders.id = bookshop_gifts.order_id
      )
      UPDATE bookshop_gifts
      SET user_id = bg.user_id
      FROM bg
      WHERE bookshop_gifts.id = bg.bookshop_gift_id
    SQL

    remove_column :bookshop_gifts, :order_id, :bigint, foreign_key: true
  end
end
