# frozen_string_literal: true

class MsControllerSpecGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_controller_spec
    template_path = "spec/controllers/#{controller_command_name.pluralize}_controller_spec.rb"
    template("ms_controller_spec.rb", template_path)
  end
end
