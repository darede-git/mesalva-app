# frozen_string_literal: true

module AlgoliaModel
  def self.included(base)
    base.extend(AlgoliaModel)
  end

  def algolia_id
    "#{model_name.name}-#{id}"
  end

  %w[uid image_url name email active].each do |attr|
    method_name = "#{attr}_changed?"
    define_method(method_name) { public_send(method_name.to_sym) }
  end
end
