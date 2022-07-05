# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Platform, type: :model do
  describe 'Validations' do
    context 'with a valid platform' do
      let(:platform) { build(:platform) }

      it 'should be valid' do
        expect(platform).to be_valid
      end
    end

    context 'without a slug' do
      let(:platform) { build(:platform, slug: nil) }
      let(:name) { platform.name.sub(' ', '-') }
      let(:hash) { Digest.hexencode(name[0..4]) }
      let(:slug) { "#{name}-#{hash}" }

      it 'should generate a token and then be valid' do
        expect(platform).to be_valid
        expect(platform.slug).to include("#{platform.name.downcase.sub(' ', '-')}-")
      end
    end

    context 'without a cnpj' do
      let(:platform) { build(:platform, cnpj: nil) }

      it 'should be valid' do
        expect(platform).to be_valid
      end
    end

    context 'with a duplicated cnpj' do
      it 'should be invalid' do
        create(:platform, cnpj: "99.999.999/9999-99")
        duplicated = FactoryBot.build(:platform, cnpj: "99.999.999/9999-99")
        expect(duplicated).not_to be_valid
      end
    end

    context 'with a invalid cnpj' do
      let(:invalid_cnpj_example) { ["999.9999.99/999.999"] }
      let(:platform) { build(:platform, cnpj: invalid_cnpj_example) }

      it 'should be invalid' do
        expect(platform).not_to be_valid
      end
    end
  end
end
