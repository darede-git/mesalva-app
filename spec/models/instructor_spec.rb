# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Instructor, type: :model do
  it { should have_many(:instructor_users) }
  it { should have_many(:users).through(:instructor_users) }

  context 'scope' do
    context 'after create' do
      context 'user has no token' do
        let!(:user) { create(:user) }

        it 'creates token' do
          user.token = nil
          user.save

          Instructor.create(user_id: user.id)

          expect(user.reload.token).not_to be_nil
        end
      end
    end
  end
end
