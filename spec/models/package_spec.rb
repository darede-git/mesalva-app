# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Package, type: :model do
  context 'validations' do
    should_be_present(:prices, :node_ids, :education_segment_slug)
    should_have_many(:features)
    it { should accept_nested_attributes_for(:bookshop_gift_packages) }

    it do
      should validate_inclusion_of(:education_segment_slug)
        .in_array(%w[
                    enem-e-vestibulares
                    ensino-medio
                    concursos
                    ciencias-da-saude
                    engenharia
                    cursos-rapidos
                    negocios
                  ])
    end
    it 'validates sales_platforms values' do
      %w[web ios android].each do |platform|
        expect do
          create(:package_valid_with_price,
                 sales_platforms: [platform])
        end.to change(Package, :count).by(1)
      end

      expect do
        create(:package_valid_with_price,
               sales_platforms: ['windows'])
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        create(:package_valid_with_price,
               sales_platforms: [nil])
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'fails when both duration and expires_at are present or empty' do
      package_without_both = FactoryBot.build(:package_invalid)
      package_with_duration = FactoryBot.build(:package_with_duration)
      package_with_expires_at = FactoryBot.build(:package_with_expires_at)
      package_with_both = duration_and_expire

      expect(package_without_both).to be_invalid
      expect(package_with_duration).to be_valid
      expect(package_with_expires_at).to be_valid
      expect(package_with_both).to be_invalid
    end

    it 'validates essay credits as greater or equal to zero' do
      expect { create(:package_valid_with_price, essay_credits: -1) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates private class credits as greater or equal to zero' do
      expect { create(:package_valid_with_price, private_class_credits: -1) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'validates essay credits are either infinite or not' do
      expect do
        create(:package_valid_with_price,
               unlimited_essay_credits: nil)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active packages' do
        create(:package_valid_with_price, :inactive)
        active = create(:package_valid_with_price, :active)
        expect(Package.active).to eq([active])
      end
    end

    context 'with education_segment' do
      let!(:node1) { create(:node, name: 'ENEM e Vestibulares') }
      let!(:node2) { create(:node, name: 'Engenharia') }
      let(:result) do
        create(:package_valid_with_price,
               listed: true, position: 0)
      end

      let(:package2) do
        create(:package_valid_with_price,
               listed: true, position: 1)
      end

      context '.ordered_by_position' do
        it 'returns packages ordered by position' do
          package1 = create(:package_valid_with_price, position: 0)

          expect(Package.ordered_by_position).to eq([package1, package2])
        end
      end

      context '.by_education_segment' do
        it 'returns only the active packages with education segment' do
          create_packages_invalids

          expect(Package.by_education_segment_slug(node1.slug))
            .to eq([result, package2])
        end
      end
    end

    context '.validate_prices_by_subscription' do
      subject do
        build(:package, subscription: true,
                        prices: [build(:price, :bank_slip)])
      end

      context 'package without boleto on slug' do
        it 'returns true' do
          expect(subject).to be_valid
        end
      end

      context 'with boleto on slug' do
        before { subject.slug = 'assinatura-por-boleto-completa' }

        it { should be_valid }

        context 'package with price by card' do
          before { subject.prices << build(:price, :credit_card) }
          it { should_not be_valid }
        end
      end
    end

    context '.listed' do
      it 'returns only the listed packages true' do
        listed_false = create(:package_valid_with_price)
        listed_true = create(:package_valid_with_price,
                             listed: true)
        expect(Package.listed(true)).to eq([listed_true])
        expect(Package.listed(false)).to eq([listed_false])
      end
    end

    context 'scopes filtering by education_segment_slug and/or platform' do
      let!(:enem_package) do
        create(:package_valid_with_price,
               sales_platforms: ['web'],
               listed: true)
      end
      let!(:engenharia_package) do
        create(:package_valid_with_price,
               education_segment_slug: 'engenharia',
               sales_platforms: ['android'],
               listed: true)
      end
      let!(:ios_enem_package) do
        create(:package_valid_with_price,
               sales_platforms: ['ios'],
               listed: true)
      end

      context '.by_education_segment_slug' do
        it 'returns packages filtered by education_segment_slug' do
          expect(Package.by_education_segment_slug('engenharia'))
            .to eq([engenharia_package])
          expect(Package.by_education_segment_slug('enem-e-vestibulares'))
            .to include(ios_enem_package, enem_package)
        end
      end

      context '.by_platform' do
        it 'returns packages filtered by platform' do
          expect(Package.by_platform('android'))
            .to eq([engenharia_package])
          expect(Package.by_platform('web'))
            .to eq([enem_package])
        end
      end

      context '.by_education_segment_slug_and_platform' do
        it 'return packages filtered by education_segment_slug and platform' do
          expect(Package.by_education_segment_slug_and_platform(
                   'engenharia', 'android'
                 )).to eq([engenharia_package])
          expect(Package.by_education_segment_slug_and_platform(
                   'enem-e-vestibulares', 'web'
                 )).to eq([enem_package])
          expect(Package.by_education_segment_slug_and_platform(
                   'enem-e-vestibulares', 'ios'
                 )).to eq([ios_enem_package])
        end
      end

      context '.full_filters' do
        context 'with a node' do
          let!(:node) { create(:node, slug: 'enem-e-vestibulares', node_type: 'education_segment') }
          context 'with packages' do
            let!(:package1) { create(:package_valid_with_price, sku: 'enem', education_segment_id: node.id) }
            let!(:package2) { create(:package_valid_with_price, sku: 'enem', education_segment_slug: node.slug) }
            context 'with a bookshop gift pacakge' do
              let!(:bookshop_gift_package) { create(:bookshop_gift_package, package_id: package2.id) }
              it 'return packages filtered by sku enem ' do
                expect(Package.full_filters({ sku: 'enem' })).to eq([package1, package2])
              end
            end
          end
        end
      end
    end
  end

  def duration_and_expire
    FactoryBot.build(:package_with_expires_at_and_duration)
  end

  context 'create with valid attributes' do
    it 'should creates a new Package' do
      expect do
        create(:package_valid_with_price)
      end.to change(Package, :count).by(1)
    end

    it 'with nested price should creates Price' do
      expect do
        create(:package_with_price_attributes)
      end.to change(Price, :count).by(1)
    end
  end

  context 'update with valid attributes' do
    it 'with nested price should update Price' do
      package = create(:package_valid_with_price)
      price = package.prices.first
      expect do
        package.update_attributes(
          prices_attributes: {
            id: price.id,
            value: price.value + 50
          }
        )
      end.to change { price.reload.value }.by(50)
    end
  end

  it 'should default the complementary field to false' do
    package = create(:package_valid_with_price)
    package.complementary.should == false
  end

  def create_packages_invalids
    create(:package_valid_with_price,
           education_segment_slug: node2.slug)
    create(:package_valid_with_price,
           :inactive,
           education_segment_slug: node1.slug)
  end
end
