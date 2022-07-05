# frozen_string_literal: true

class User::Dashboards::TestRepositoryController < ApplicationController
  before_action -> { authenticate(%w[user]) }

  def index
    render json: user_stats, adapter: :attributes
  end

  def show
    query = user_answers
    return render_not_found if query.results.empty?

    render json: query,
           serializer: User::Dashboards::TestRepositorySerializer,
           adapter: :attributes
  end

  private

  def user_answers
    MeSalva::Event::User::Content::TestRepository
      .new(current_user, test_repo_params[:submission_token])
  end

  def user_stats
    MeSalva::Event::User::Content::TestRepository.new(current_user)
                                                 .counters
  end

  def test_repo_params
    params.permit(:submission_token)
  end
end
