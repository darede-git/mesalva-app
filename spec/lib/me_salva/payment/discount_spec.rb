# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Payment::Discount do
  let!(:package) { create(:package_valid_with_price) }
  let!(:package_upsell) { create(:package_valid_with_price) }
  let!(:subscription_package) { create(:package_subscription) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:discount_valid) { create(:discount) }

  context 'valid discount' do
    context '#default' do
      context 'for all packages' do
        context 'without a user' do
          let!(:discount) { create(:discount, :for_all_packages) }
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end

        context 'with a specific user' do
          let!(:discount) do
            create(:discount, :for_all_packages, user_id: user.id)
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end
      end

      context 'with a specific package' do
        context 'without a user' do
          let!(:discount) do
            create(:discount, packages: [package.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end

        context 'and a specific user' do
          let!(:discount) do
            create(:discount, user_id: user.id,
                              packages: [package.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end
      end
    end

    context '#upsell' do
      before do
        create(:access_with_duration,
               package: package_upsell,
               user_id: user.id)
      end
      context 'for all packages' do
        context 'without a user' do
          let!(:discount) do
            create(:discount, :for_all_packages,
                   upsell_packages: [package_upsell.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end

        context 'with a specific user' do
          let!(:discount) do
            create(:discount, :for_all_packages,
                   user_id: user.id,
                   upsell_packages: [package_upsell.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end
      end

      context 'with a specific package' do
        context 'without a user' do
          let!(:discount) do
            create(:discount, upsell_packages: [package_upsell.id],
                              packages: [package.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end

        context 'with a specific user' do
          let!(:discount) do
            create(:discount, user_id: user.id,
                              upsell_packages: [package_upsell.id],
                              packages: [package.id])
          end
          it 'returns true' do
            assert_discount_validator(package, discount, user, true)
          end
        end
      end
    end

    context '#only_customer' do
      context 'with access still valid' do
        context 'within the only costumer valid period' do
          before do
            create(:access_with_duration,
                   expires_at: Date.today + 30.days,
                   package: package,
                   user_id: user.id)
          end
          context 'for all packages' do
            context 'without a user' do
              let!(:discount) { create(:discount_only_customer, :for_all_packages) }
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
            context 'with a specific user' do
              let!(:discount) do
                create(:discount_only_customer, :for_all_packages, user_id: user.id)
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
          end
          context 'with a specific package' do
            context 'without a user' do
              let!(:discount) do
                create(:discount_only_customer, packages: [package.id])
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
            context 'with a specific user' do
              let!(:discount) do
                create(:discount_only_customer,
                       user_id: user.id,
                       packages: [package.id])
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
          end
        end
      end
      context 'with access expired' do
        context 'within the only costumer valid period' do
          before do
            create(:access_with_duration,
                   expires_at: Date.today - 15.days,
                   package: package,
                   user_id: user.id)
          end
          context 'for all packages' do
            context 'without a user' do
              let!(:discount) do
                create(:discount_only_customer, :expired, :for_all_packages,
                       only_customer: true)
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
            context 'with a specific user' do
              let!(:discount) do
                create(:discount_only_customer, :expired, :for_all_packages,
                       user_id: user.id)
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
          end
          context 'with a specific package' do
            context 'without a user' do
              let!(:discount) do
                create(:discount_only_customer, :expired,
                       packages: [package.id])
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
            context 'with a specific user' do
              let!(:discount) do
                create(:discount_only_customer, :expired,
                       user_id: user.id,
                       packages: [package.id])
              end
              it 'returns true' do
                assert_discount_validator(package, discount, user, true)
              end
            end
          end
        end
      end
    end
  end

  context 'invalid discount' do
    context 'without package' do
      it 'returns false' do
        assert_discount_validator(nil, discount_valid, user, false)
      end
    end

    context 'without discount' do
      it 'returns false' do
        assert_discount_validator(package, nil, user, false)
      end
    end

    context 'with invalid date' do
      let!(:discount) do
        create(:discount, :expired, :for_all_packages)
      end
      it 'returns false' do
        assert_discount_validator(package, discount, user, false)
      end
    end

    context 'with invalid user' do
      let!(:discount) do
        create(:discount, :for_all_packages, user_id: user.id)
      end
      it 'returns false' do
        assert_discount_validator(package, discount, user2, false)
      end
    end

    context 'with invalid packages' do
      let!(:discount) do
        create(:discount, packages: [package.id])
      end
      it 'returns false' do
        assert_discount_validator(package_upsell, discount, user, false)
      end
    end

    context 'with invalid upsell' do
      let!(:discount) do
        create(:discount, :for_all_packages,
               upsell_packages: [package_upsell.id])
      end
      it 'returns false' do
        assert_discount_validator(package, discount, user, false)
      end
    end

    context 'with invalid only costumer discount' do
      context 'for all packages' do
        context 'with access out of only costumer rule range' do
          context 'before the last 30 days of access' do
            before do
              create(:access_with_duration,
                     expires_at: Date.today + 31.days,
                     package: package,
                     user_id: user.id)
            end
            let!(:discount) { create(:discount_only_customer, :for_all_packages) }
            it 'returns false' do
              assert_discount_validator(package, discount, user, false)
            end
          end
          context 'after the first 15 days of expired access' do
            before do
              create(:access_with_duration,
                     expires_at: Date.today - 16.days,
                     package: package,
                     user_id: user.id)
            end
            let!(:discount) { create(:discount_only_customer, :for_all_packages) }
            it 'returns false' do
              assert_discount_validator(package, discount, user, false)
            end
          end
        end
      end
      context 'with a specific package' do
        context 'with access out of only costumer rule range' do
          context 'before the last 30 days of access' do
            before do
              create(:access_with_duration,
                     expires_at: Date.today + 31.days,
                     package: package,
                     user_id: user.id)
            end
            let!(:discount) { create(:discount_only_customer, :for_all_packages) }
            it 'returns false' do
              assert_discount_validator(package, discount, user, false)
            end
          end
          context 'after the first 15 days of expired access' do
            before do
              create(:access_with_duration,
                     expires_at: Date.today - 16.days,
                     package: package,
                     user_id: user.id)
            end
            let!(:discount) { create(:discount_only_customer, :for_all_packages) }
            it 'returns false' do
              assert_discount_validator(package, discount, user, false)
            end
          end
        end
      end
    end

    context 'with subscription package' do
      let!(:discount) { create(:discount, :for_all_packages) }
      it 'returns false' do
        assert_discount_validator(subscription_package, discount, user, false)
      end
    end
  end

  def assert_discount_validator(package, discount, user, valid)
    expect(MeSalva::Payment::Discount.new.valid?(package, discount, user))
      .to eq(valid)
  end
end
