# frozen_string_literal: true

class MsScaffoldGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_controller_scaffold
    generate "ms_controller #{controller_command_with_args}"
    generate "resource_route #{controller_command_with_args}"
    generate "ms_controller_spec #{controller_command_with_args}"
  end

  def generate_ms_model_scaffold
    generate "migration create_#{file_name} #{args_to_formatted_string}"
    generate "ms_model #{controller_command_with_args}"
    generate "ms_model_spec #{controller_command_with_args}"
    generate "ms_serializer #{controller_command_with_args}"
    generate "ms_factory #{file_name} #{args_to_formatted_string}"
  end

  def customize_files
    custom_file("db/migrate/", file_name)
  end
end
