# frozen_string_literal: true

class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :city, :state, presence: true
  validates :zip_code,
            format: { with: /\A[0-9]{5}-[0-9]{3}\z/,
                      message: I18n.t('errors.messages.invalid_zip') },
            allow_blank: true
end
