# frozen_string_literal: true

class CommentsController < ApplicationController
  include PermalinkAuthorization

  before_action -> { authenticate(authorized_roles) }, except: :index,
                                                       unless: :internal_note?
  before_action :set_comment, only: %i[update destroy]
  before_action :set_comments, only: :index
  before_action :validate_access, only: :create
  before_action :own_comment?, only: :update

  def index
    return render_not_found if ENV['DISABLE_COMMENTS'] == 'true'

    page = params['page'] || 1
    render_ok(@comments.page(page))
  end

  def create
    comment = Comment.new(valid_comment_params)
    if comment.save
      render_created(comment)
    else
      render_unprocessable_entity(comment.errors)
    end
  end

  def update
    if @comment.update(comment_params)
      render_ok(@comment)
    else
      render_unprocessable_entity(@comment.errors)
    end
  end

  private

  def authorized_roles
    return %w[admin teacher] if essay_submission_comment?

    %w[admin teacher user]
  end

  def valid_comment_params
    return comment_params_with_foreign_key unless commented_entity_column.nil?

    return nil unless params.key?(:permalink_slug) && valid_permalink?

    comment_params.merge(commentable: @permalink.medium)
  end

  def commented_entity_column
    params.keys.map { |key| return key if key.end_with?('_id') }
    nil
  end

  def commented_entity_model
    commented_entity_column.try(:chomp, '_id').try(:camelcase).try(:constantize)
  end

  def essay_submission_comment?
    params[:essay_submission_id].present?
  end

  def comment_params_with_foreign_key
    comment_params.merge('commentable' => commented_entity)
  end

  def commented_entity
    commented_entity_model.find_by_token(params[commented_entity_column])
  end

  def own_comment?
    return if promoter?

    render_unauthorized if @comment.commenter != current_user
  end

  def set_comment
    @comment = Comment.find_by_token(params[:id])
    render_not_found if @comment.nil?
  end

  def set_comments
    return @comments = comment_by_medium if valid_permalink?

    render_unprocessable_entity(t('permalink.invalid_permalink'))
  end

  def comment_by_medium
    Comment.by_medium(@permalink.medium_id)
  end

  def comment_params
    params.permit(:text, :active).merge(commenter: current_role)
  end

  def internal_note?
    controller_name == 'internal_notes'
  end

  def validate_access
    return if promoter?

    return render_unauthorized unless current_user

    return render_unprocessable_entity unless valid_permalink?

    return if free_medium?

    return render_payment_required unless valid_comment_access?
  end

  def valid_permalink?
    @permalink = Permalink.find_by_slug(params['permalink_slug'])
    @permalink&.medium_id.present?
  end

  def free_medium?
    @permalink&.item&.free
  end

  def promoter?
    current_admin || current_teacher
  end

  def current_role
    current_admin || current_teacher || current_user
  end

  def valid_comment_access?
    node_ids = @permalink.node_ids
    permalink_access.validate(node_ids, current_user)
  end
end
