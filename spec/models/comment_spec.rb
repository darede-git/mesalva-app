# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validations' do
    should_be_present(:commentable, :text)
    should_be_present(:commenter, :text)
  end

  context 'scopes' do
    context '.by_medium' do
      let(:medium) { create(:medium) }
      let(:user) { create(:user) }
      let(:comment) do
        create(:comment, commentable: medium, commenter: user)
      end
      it 'return the mediums comments' do
        expect(Comment.by_medium(medium)).to eq([comment])
      end
    end
  end
end
