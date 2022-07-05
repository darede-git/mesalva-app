# frozen_string_literal: true

class MsFactoryGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_factory
    template("ms_factory.rb", "spec/factories/#{@file_name.pluralize}.rb")
  end
end
