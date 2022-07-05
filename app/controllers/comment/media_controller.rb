# frozen_string_literal: true

class Comment::MediaController < BaseCommentsController
  include PermalinkAuthorization

  before_action -> { authenticate(%w[user admin teacher]) }, except: :index
  before_action :set_comment, only: :update
  before_action :validate_comment_ownership, only: :update
  before_action :set_permalink
  before_action :set_commentable
  before_action :set_comments, only: :index
  before_action :validate_access, only: :create

  private

  def validate_access
    return unless current_role.is_a? User

    return if current_user_has_valid_access?

    render_payment_required
  end

  def validate_comment_ownership
    return unless current_role.is_a? User

    return if own_comment?

    render_unauthorized
  end

  def own_comment?
    @comment.commenter == current_user
  end

  def set_commentable
    @commentable = @permalink&.medium
  end

  def set_comment
    @comment = Comment.find_by_token(params[:token])
  end

  def set_permalink
    @permalink = Permalink.find_by_slug(params[:permalink_slug])
  end

  def set_comments
    @comments = @commentable.comments
  end

  def current_user_has_valid_access?
    permalink_access.validate(@permalink.node_ids, current_user)
  end
end
