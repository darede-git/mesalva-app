# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EssayMark, type: :model do
  context 'validations' do
    should_be_present(:description, :mark_type, :essay_submission, :coordinate)
    it do
      should validate_inclusion_of(:mark_type).in_array(%w[ortografia
                                                           regencia
                                                           semantica
                                                           concordancia
                                                           pontuacao
                                                           diverso])
    end
  end
end
