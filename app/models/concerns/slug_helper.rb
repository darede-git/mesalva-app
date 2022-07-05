# frozen_string_literal: true

module SlugHelper
  extend ActiveSupport::Concern
  included do
    before_validation :set_slug, unless: :slug?
  end

  def set_slug
    return unless slug_column

    self.slug = ActiveSupport::Inflector.transliterate(sanitized_column)
  end

  private

  def slug?
    return true unless slug.nil?
  end

  def slug_column
    try(:name) || try(:title)
  end

  def sanitized_column
    slug_column
      .mb_chars
      .downcase
      .to_s
      .gsub(/[^0-9a-z_áéíóúãẽĩõũàèìòùäëïöüâêîôûç\s]/, '')
      .gsub(/\s+/, ' ')
      .strip
      .tr('_', '-')
      .gsub(/\s/, '-')
  end

  def friendly_code(length = 8)
    ([*('A'..'Z'),*('a'..'z'),*('0'..'9')]).sample(length).join
  end
end
