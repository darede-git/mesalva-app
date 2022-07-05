# frozen_string_literal: true

module SlugAssertionHelper
  def create_and_assert_slug(entity, slug_column)
    new_entity = create(entity.to_sym)
    expect(new_entity.slug).to eq new_entity.send(slug_column.to_s)
  end

  def assert_valid(entity)
    inactive_model = create_model(entity, false)
    model = create_model(entity)
    expect(entity.classify.constantize.active).to include(model)
    expect(entity.classify.constantize.active).not_to include(inactive_model)
  end

  def create_model(entity, active = true)
    create(entity.to_sym, active: active)
  end
end
