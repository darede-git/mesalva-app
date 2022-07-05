# frozen_string_literal: true

class MsModelGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_model
    template("ms_model.rb", "app/models/#{namespace_folder(controller_class_name)}#{@file_name}.rb")
  end
end
