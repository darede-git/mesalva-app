# frozen_string_literal: true

module FixturesHelper
  def json_fixture(name)
    JSON.parse(File.read("spec/fixtures/#{name}.json"))
  end

  def default_test_image
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAY'
  end
end
