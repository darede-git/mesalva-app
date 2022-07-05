# frozen_string_literal: true

module MeSalva
  module Vouchers
    class BookshopGiftsRemanager
      def between_packages(from_id, to_id)
        from_package = Package.find(from_id)
        to_package = Package.find(to_id)

        from_bookshop_gift_packeage_id = from_package.bookshop_gift_packages.first.id
        to_bookshop_gift_package_id = to_package.bookshop_gift_packages.first.id

        between_bookshop_gift_packages(from_bookshop_gift_packeage_id, to_bookshop_gift_package_id)
      end

      def between_bookshop_gift_packages(from_id, to_id)
        keep_quantity = 3
        @from_bookshop_gift_packeage_id = from_id

        scaped_bookshop_gifts = unused_bookshop_gifts.limit(keep_quantity).pluck(:id)
        unused_bookshop_gifts.where.not(id: scaped_bookshop_gifts)
                             .update_all(bookshop_gift_package_id: to_id)
      end

      private

      def unused_bookshop_gifts
        BookshopGift.where(bookshop_gift_package_id: @from_bookshop_gift_packeage_id, order_id: nil)
      end
    end
  end
end
