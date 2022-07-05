# frozen_string_literal: true

module StudyPlanNodeModuleHelper
  %w[first last].each do |m|
    define_method("#{m}_node_module_id") do
      node_modules.public_send(m.to_sym).id.to_s
    end
  end
end
