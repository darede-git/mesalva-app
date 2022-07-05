# frozen_string_literal: true

class RemoveCodeFromUserReferrals < ActiveRecord::Migration[5.2]
  def up
    UserReferral.where('confirmed_referrals > 0').each do |user_referral|
      user_referral.user.update(token: user_referral.code)
    end

    remove_column :user_referrals, :code
  end

  def down
    add_column :user_referrals, :code, :string
  end
end
