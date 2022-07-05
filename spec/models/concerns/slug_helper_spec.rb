# frozen_string_literal: true

require 'rails_helper'

describe SlugHelper do
  describe '#set_friendly_name' do
    context 'with special characters' do
      it 'chages special caracters to regular ones' do
        node = create(:node, name: '1º ano á é i ó ú @ %')
        expect(node.slug).to eq('1-ano-a-e-i-o-u')
      end
    end

    context 'with space and hyphen' do
      it 'removes the spaces' do
        node = create(:node, name: 'Raio X - ENEM')
        expect(node.slug).to eq('raio-x-enem')
      end
    end

    context 'name starts with uppercase and accent' do
      it 'replaces the underscore with a dash' do
        node = create(:node, name: 'Álgebra Linear')
        expect(node.slug).to eq('algebra-linear')
      end
    end

    context 'name has underscore' do
      it 'replaces the underscore with a dash' do
        node = create(:node, name: 'Matemática_enem')
        expect(node.slug).to eq('matematica-enem')
      end
    end

    context 'with a name starting or ending with a parentesis' do
      it 'removes the hyphens' do
        node = create(:node, name: '(2016) Extensivo de Matemática')
        expect(node.slug).to eq('2016-extensivo-de-matematica')
      end
    end

    context 'update name' do
      it 'changes the name without changing the slug' do
        node = create(:node, name: '(2027) Extensivo ENEM')
        node.update(name: '(2017) Extensivo ENEM')
        expect(node.slug).to eq('2027-extensivo-enem')
      end
    end
  end
end
