# frozen_string_literal: true

module MetaTagsHelper
  extend ActiveSupport::Concern

  included do
    validate :meta_description_size
    validate :meta_title_size
  end

  private

  def meta_description_size
    return if valid_meta_description_size?

    errors.add(:meta_description, I18n.t('errors.messages.meta_description'))
  end

  def meta_title_size
    return if valid_meta_title_size?

    errors.add(:meta_description, I18n.t('errors.messages.meta_title'))
  end

  def valid_meta_description_size?
    valid_attribute_size?(meta_description,
                          ENV['META_DESCRIPTION_LIMIT_SIZE'].to_i)
  end

  def valid_meta_title_size?
    valid_attribute_size?(meta_title, ENV['META_TITLE_LIMIT_SIZE'].to_i)
  end

  def valid_attribute_size?(attr_value, limit_size)
    return true if attr_value.nil?

    limit_size >= attr_value.size
  end
end
