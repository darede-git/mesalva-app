# frozen_string_literal: true

class MediaController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[admin]) },
                only: %i[create update destroy mass_creation]
  before_action :set_medium, only: %i[update destroy]
  before_action :authenticate_permission, only: :show_by_id

  include AuthorshipConcern
  include MediumShowConcern
  include Cache
  include RemovableEntityRelativesConcern

  def show_by_id
    @medium = Medium.find(params[:id])
    render json: serialize(@medium, serializer: 'Content', v:1)
  end

  def show
    render json: @medium,
           status: :ok,
           serializer: show_serializer,
           include: ['answers'],
           options: { client: request.headers['client'] }
  end

  def create
    @medium = Medium.new(medium_params.merge(platform_params))
    if @medium.save
      unzip unless @medium.medium_type != 'book'
      render json: @medium,
             status: :created,
             include: [:answers],
             serializer: EntityMediumSerializer
    else
      render_unprocessable_entity(@medium.errors.messages)
    end
  end

  def mass_creation
    @created_media = []
    mass_creation_params.each do |valid_param|
      medium = Medium.new(valid_param)
      if medium.save
        @created_media << medium
      else
        unless @created_media.empty?
          return render json: created_media,
                        status: :partial_content,
                        include: [:answers],
                        each_serializer: EntityMediumSerializer
        end
        return render_unprocessable_entity(medium.errors.messages)
      end
    end
    render json: @created_media,
           status: :created,
           include: [:answers],
           each_serializer: EntityMediumSerializer
  end

  def update
    if @medium.update(medium_update_params.merge(platform_params))
      render_ok(@medium)
    else
      render_unprocessable_entity(@medium.errors.messages)
    end
  end

  def destroy
    @medium.destroy
    render_no_content
  end

  private

  def unzip
    AttachmentUploaderWorker.perform_async(@medium.slug)
  end

  def set_medium
    @medium = Medium.find(params[:id])
  end

  def medium_params
    params.permit(:active,      :attachment, :code,
                  :concourse,   :correction, :created_by,
                  :description, :difficulty, :seconds_duration,
                  :matter,      :subject,    :medium_type,
                  :name,        :provider,   :medium_text,
                  :video_id,    :updated_by, :audit_status,
                  :placeholder, :listed,     options: {},
                                             item_ids: [], answers_attributes: answers_attributes)
  end

  def mass_creation_params
    params.require(:media).map do |medium|
      medium.permit(:active, :attachment, :code, :concourse, :correction, :created_by,
                    :description, :difficulty, :seconds_duration, :matter, :subject, :medium_type,
                    :name, :provider, :medium_text, :video_id, :updated_by, :audit_status,
                    :placeholder, tag: [], answers_attributes: answers_attributes)
    end
  end

  def medium_update_params
    medium_params.merge(params.permit(node_ids: [], node_module_ids: [], item_ids: []))
  end

  def answers_attributes
    %i[id text explanation active correct]
  end

  def show_serializer
    return Permalink::Relation::ChildMediumAnswerSerializer if show_answers?

    Permalink::Relation::ChildMediumSerializer
  end

  def show_answers?
    return true if request.headers['client'] == "APP_ENEM"
    return false if @user_platform.nil?

    @user_platform.role == 'admin'
  end

  def platform_params
    return { platform_id: @platform.id } if @platform

    {}
  end
end
