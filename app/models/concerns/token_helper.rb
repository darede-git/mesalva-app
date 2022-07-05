# frozen_string_literal: true

# converters receive a lambda to customize the token

module TokenHelper
  def generate_token(column: :token, overwrite: false, converters: nil)
    return self[column] if already_tokenized(column, overwrite)

    loop do
      self[column] = new_token(converters)
      break unless token_already_exists?(column)
    end
    self[column]
  end

  private

  def token_already_exists?(column)
    self.class.exists?(column => self[column])
  end

  def new_token(converters)
    random_token = SecureRandom.urlsafe_base64
    return random_token if converters.nil?

    converters.call(random_token)
  end

  def already_tokenized(column, overwrite)
    !overwrite && self[column].present?
  end
end
