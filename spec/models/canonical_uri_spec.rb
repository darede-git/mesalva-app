# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CanonicalUri, type: :model do
  describe 'validations' do
    context 'there is no permalink with the given slug' do
      it 'should invalidate the entity' do
        canonical_uri = CanonicalUri.new(slug: 'i-do-not-exist')
        expect { canonical_uri.save! }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'there is a permalink with the given slug' do
      let!(:permalink) do
        create(:permalink, slug: 'permalink-slug')
      end
      it 'should create a new entity' do
        canonical_uri = CanonicalUri.new(slug: 'permalink-slug')
        expect { canonical_uri.save! }
          .to change(CanonicalUri, :count).by(1)
      end
    end
  end
end
