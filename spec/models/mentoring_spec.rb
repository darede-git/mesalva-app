# frozen_string_literal: true

RSpec.describe Mentoring, type: :model do
  context 'validations' do
    should_be_present(:user_id, :content_teacher_id)
  end
end
