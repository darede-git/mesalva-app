# frozen_string_literal: true

class MsSerializerGenerator < Rails::Generators::NamedBase
  include Rails::Generators::ResourceHelpers
  include GeneratorHelper

  source_root File.expand_path('templates', __dir__)

  def generate_ms_serializer
    serializer_name = "#{namespace_folder(controller_class_name)}#{@file_name}"
    template("ms_serializer.rb", "app/serializers/v2/#{serializer_name}_serializer.rb")
  end
end
