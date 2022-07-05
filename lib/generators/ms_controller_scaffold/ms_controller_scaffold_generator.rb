# frozen_string_literal: true

class MsControllerScaffoldGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_controller_scaffold
    generate "ms_controller #{controller_command_with_args}"
    generate "resource_route #{controller_command_with_args}"
    generate "ms_controller_spec #{controller_command_with_args}"
  end
end
