# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'an entity with meta tags' do |entity_class|
  include ContentStructureCreationHelper

  context 'validate meta tags values' do
    let(:entity) do
      FactoryBot.build(entity_class.name.underscore.to_sym)
    end
    context 'meta description size' do
      context 'meta description is too long' do
        it { raises_error_for('description', 170) }
      end

      context 'meta description has valid size' do
        it { increases_entity_count_for(entity) }
      end
    end

    context 'meta title size' do
      context "meta title is too long" do
        it { raises_error_for('title', 60) }
      end
      context 'meta title has valid size' do
        it { increases_entity_count_for(entity) }
      end
    end
  end

  def raises_error_for(attr, size)
    attribute = "meta_#{attr}=".to_sym
    entity.public_send(attribute, string_with_size_bigger_than(size))

    expect { entity.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  def increases_entity_count_for(entity)
    expect do
      entity.save!
    end.to change(entity.class, :count).by(1)
  end
end
