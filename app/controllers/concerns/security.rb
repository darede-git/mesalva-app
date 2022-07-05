# frozen_string_literal: true

module Security
  extend ActiveSupport::Concern

  def authenticate_admin
    authenticate(%w[admin])
  end

  def authenticate_user
    authenticate(%w[user])
  end

  def authenticate(roles)
    render_unauthorized unless authorized_role?(roles)
  end

  def authenticate_permission(context = nil, action = nil)
    return render_unauthorized unless user_signed_in? || admin_signed_in?

    user = admin_signed_in? ? User.by_admin_uid(current_admin.uid).take : current_user

    return render_unauthorized('errors.messages.old_admin_reference') if user.nil?

    unless Permission.validate_user(context || params[:controller], action || params[:action], user)
      render_default_error("#{t('errors.messages.unauthenticated_permission')}: #{params[:controller].gsub(/\//, '-')}/#{params[:action]}", :unauthorized)
    end
  end

  def authorized_role?(roles)
    roles.any? { |role| resource_present?(role) }
  end

  def authorized_platform_role?(roles)
    roles.map! { |role| role.gsub('user', 'student') }
    roles.any? { |role| @user_platform.role == role }
  end

  def authenticate_permalink_access(roles)
    return authenticate(roles) if current_user.nil?

    return nil if super_admin?

    if resource_token_platform_id?
      platform_id = current_user.tokens[@client_id]['platform_id']
      @platform = Platform.find_by_id(platform_id)
    end

    return authenticate(roles) unless @platform.present?

    set_security_user_platform(roles)
    return render_unauthorized unless @user_platform

    authorize_platform_user_role(roles) if @user_platform
  end

  def authenticate_permalink_update(roles)
    return if authenticate_permalink_access(roles)

    authorize_platform_update if @platform
  end

  def authorize_platform_user_role(roles)
    return render_unauthorized unless authorized_platform_role?(roles)

    authorize_platform_relationship if related_nodes_params_present?
  end

  def authorize_platform_relationship
    render_unauthorized unless related_nodes_have_platform_id?
  end

  def set_security_user_platform(roles, platform_slug = nil)
    @platform = Platform.find_by_slug(platform_slug) if platform_slug
    if current_user
      @platform ||= Platform.find_by_id(current_user.tokens[@client_id]['platform_id'])
      @user_platform = UserPlatform.where(user_id: current_user.id, platform_id: @platform&.id).take
      set_admin_platform(roles) unless @user_platform
    end
  end

  def set_admin_platform(roles)
    return nil unless roles.include?('admin')

    @user_platform = UserPlatform.joins('INNER JOIN platforms ON platforms.id = user_platforms.platform_id')
                                 .where(user_id: current_user.id, "platforms.slug": 'admin', role: 'admin').take
  end

  def show_action?
    action_name == 'show'
  end

  def invalid_fields?
    return true if params['uid']

    (profile_params.keys.map(&:to_sym) - role_params).any?
  end

  def profile_params
    params.permit(valid_params)
  end

  def set_resource
    @resource = requested_resource
  end

  def set_resource_authorization
    @resource = reset_resource
    update_auth_headers
  end

  def reset_resource
    return current_admin if current_admin

    requested_resource
  end

  def requested_resource
    current_role || role_class.find_by_uid(params['uid'])
  end

  def role
    controller_path[/^[a-z]+/]
  end

  def current_role
    instance_eval("current_#{role}")
  end

  def role_class
    role.titleize.constantize
  end

  def related_nodes_params_present?
    params[:parent_id].present? || params[:node_ids].present? ||
      params[:node_module_ids].present? || params[:item_ids].present?
  end

  def related_nodes_have_platform_id?
    related_platform_nodes.all? { |related| related.platform_id == @platform.id }
  end

  # rubocop:disable Metrics/AbcSize
  def related_platform_nodes
    if params[:parent_id].present?
      [Node.find(params[:parent_id].to_i)]
    elsif params[:node_ids].present?
      Node.where(given_permalink_node_ids(:node_ids))
    elsif params[:node_module_ids].present?
      NodeModule.where(given_permalink_node_ids(:node_module_ids))
    elsif params[:item_ids].present?
      Item.where(given_permalink_node_ids(:item_ids))
    else
      render_unprocessable_entity
    end
  end

  # rubocop:enable Metrics/AbcSize

  def given_permalink_node_ids(entity_ids)
    ["id = ANY(ARRAY[?])", params[entity_ids].map(&:to_i)]
  end
end
