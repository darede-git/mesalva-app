# frozen_string_literal: true

class MsControllerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_controller
    controller_filename = "#{namespace_folder(controller_class_name)}#{@file_name.pluralize}"
    template_path = "app/controllers/#{controller_filename}_controller.rb"
    template("ms_controller.rb", template_path)
  end
end
