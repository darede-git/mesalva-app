# frozen_string_literal: true

class BaseCommentsController < ApplicationController
  def index
    page = params['page'] || 1
    render_ok(@comments.page(page))
  end

  def create
    comment = Comment.new(create_permited_params)
    if comment.save
      render_created(comment)
    else
      render_unprocessable_entity(comment.errors)
    end
  end

  def update
    return render_not_found if @comment.nil?

    if @comment.update(update_permited_params)
      render_ok(@comment)
    else
      render_unprocessable_entity(@comment.errors)
    end
  end

  private

  def create_permited_params
    update_permited_params.merge(commenter: current_role)
  end

  def update_permited_params
    params.permit(:text, :active).merge(commentable: @commentable)
  end

  def current_role
    current_user || current_admin || current_teacher
  end
end
