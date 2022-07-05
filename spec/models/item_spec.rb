# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  include SlugAssertionHelper
  include RelationshipOrderAssertionHelper

  it_should_behave_like 'an entity with meta tags', Item
  it_should_behave_like 'a searchable entity', Item

  context 'validations' do
    should_be_present(:name, :slug)
    should_have_many(:permalinks, :node_modules, :media)
    should_have_one(:public_document_info)
    it do
      should validate_inclusion_of(:item_type)
        .in_array(%w[
                    video
                    fixation_exercise
                    essay
                    text
                    prep_test
                    streaming
                    public_document
                    essay_video
                    correction_video
                  ])
    end
    it 'validates streaming items' do
      item = create(:item, :scheduled_streaming)
      expect(item.chat_token).not_to be nil
      expect(item.streaming_status).not_to be nil
    end

    it 'validates essay_video items' do
      item = create(:item, :essay_video)
      expect(item.free).to be false
      expect(item.item_type).to eq('essay_video')
    end

    it 'validates correction_video items' do
      item = create(:item, :correction_video)
      expect(item.free).to be false
      expect(item.item_type).to eq('correction_video')
    end

    context 'public document' do
      let(:item_document) { FactoryBot.build(:item, :public_document) }

      it 'should be valid' do
        expect(item_document).to be_valid
      end

      it 'should not be valid' do
        item_document.created_by = nil
        item_document.description = nil
        expect(item_document).not_to be_valid
      end
    end
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active nodes' do
        assert_valid('item')
      end
    end
  end

  context 'on save' do
    it 'should create slug' do
      item = create(:item)
      expect(item.slug).not_to be nil
      expect(item.slug).to eq item.name
    end
  end

  context 'item has many media' do
    it 'orders items by position' do
      assert_relationship_id_ordering(:item, :medium)
    end
    it 'counts only related media' do
      item = create(:item)
      related_media_ids = create_list(:medium, 5).map(&:id)
      create_list(:medium, 15)
      item.medium_ids = related_media_ids
      expect(item.medium_count['video']).to eq 5
    end
  end
end
