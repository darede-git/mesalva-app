# frozen_string_literal: true

class MsModelSpecGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_model_spec
    template_path = "spec/models/#{namespace_folder(controller_class_name)}#{@file_name}_spec.rb"
    template("ms_model_spec.rb", template_path)
  end
end
