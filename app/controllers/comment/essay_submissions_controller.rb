# frozen_string_literal: true

class Comment::EssaySubmissionsController < BaseCommentsController
  before_action -> { authenticate(%w[admin teacher]) }
  before_action :set_commentable
  before_action :set_comment, only: :update

  private

  def set_commentable
    @commentable = EssaySubmission.find_by_token(params[:essay_submission_id])
  end

  def set_comment
    @comment = Comment.find_by_token(params[:token])
  end
end
