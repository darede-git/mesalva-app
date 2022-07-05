# frozen_string_literal: true

module AuthorshipConcern
  extend ActiveSupport::Concern

  included { before_action :set_authorship, only: %i[create update] }

  def set_authorship
    params_sanitizer
    return params[attribute] = current_user.uid if @platform

    params[attribute] = current_admin.uid
  end

  def params_sanitizer
    %w[created_by updated_by].each do |action|
      params.delete(action.to_sym)
    end
  end

  def attribute
    "#{params[:action]}d_by".to_sym
  end
end
