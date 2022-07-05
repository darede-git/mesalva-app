# frozen_string_literal: true

class InternalNotesController < BaseCommentsController
  before_action -> { authenticate(%w[admin]) }
  before_action :set_internal_note, only: %i[update destroy]
  before_action :set_commentable, only: %i[index create]
  before_action :set_internal_notes, only: :index

  def destroy
    @comment.destroy
    render_no_content
  end

  private

  def create_permited_params
    update_permited_params.merge(commenter: current_role)
                          .merge(commentable: @commentable)
  end

  def update_permited_params
    params.permit(:text, :active)
  end

  def set_commentable
    @commentable = User.find_by_uid(params[:user_uid])
    render_not_found unless @commentable
  end

  def set_internal_notes
    @comments = @commentable.internal_notes
  end

  def set_internal_note
    @comment = Comment.find_by_token(params[:token])
    render_not_found unless @comment
  end
end
