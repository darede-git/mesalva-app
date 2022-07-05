# frozen_string_literal: true

require 'me_salva/permalinks/exercise_list'

class Permalink::ExerciseListsController < BasePermalinkController
  before_action -> { authenticate(%w[user]) }

  def show
    render json: MeSalva::Permalinks::ExerciseList.new(@permalink.slug).results
  end
end
