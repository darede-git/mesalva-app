# frozen_string_literal: true

module MeSalva
  module Error
    class BookshopGiftsRanOutError < StandardError
      attr_reader :message, :status_code, :body, :id

      def initialize(id)
        @message = I18n.t('book_shop_gift.error.gifts_ran_out', id: id)
        super(@message)
      end
    end
  end
end
