# frozen_string_literal: true

class PlatformsController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[admin]) }, only: %i[index create update]
  before_action :set_platform, only: %i[show update]

  def index
    render json: serialize(Platform.all, meta: show_meta, include: %i[platform_unities]), status: :ok
  end

  def show
    if @platform
      render json: serialize(@platform, meta: show_meta, include: %i[platform_unities]), status: :ok
    else
      render_not_found
    end
  end

  def update
    return render_not_found unless @platform

    if @platform.update(platform_params)
      render json: serialize(@platform, meta: show_meta, include: %i[platform_unities]), status: :ok
    else
      render_unprocessable_entity(@platform.errors)
    end
  end

  def create
    @platform = Platform.new(platform_params)
    return render json: serialize(@platform, meta: show_meta, include: %i[platform_unities]), status: :created if @platform.save!

    render_unprocessable_entity(@platform.errors)
  end

  private

  def set_platform
    render_not_found unless params[:platform_slug].present?
    set_security_user_platform(%w[user teacher admin], params[:platform_slug])
    set_platform_navigation
  end

  def platform_params
    params.permit(:name, :slug, :cnpj, :mail_invite, :mail_grant_access,
                  unity_types: [], theme: {}, navigation: {}, panel: {}, options: {})
  end

  def set_platform_navigation
    return remove_navigation if @user_platform.nil?

    decorate_navigation('header', 'menu')
    decorate_navigation('sidebar', 'content')
  end

  def remove_navigation
    remove_navigation_field('header', 'menu')
    remove_navigation_field('sidebar', 'content')
  end

  def remove_navigation_field(nav, content)
    return nil if no_platform_navigation?(nav)

    @platform.navigation[nav][content] = []
  end

  def no_platform_navigation?(nav)
    @platform.navigation.nil? || @platform.navigation[nav].nil?
  end

  def decorate_navigation(nav, content)
    return nil if no_platform_navigation?(nav)

    all_header_menus = @platform.navigation[nav][content]
    @platform.navigation[nav][content] = []
    all_header_menus.each do |menu|
      if menu['roles']
        @platform.navigation[nav][content] << menu if menu['roles'].include?(@user_platform.role)
      else
        @platform.navigation[nav][content] << menu
      end
    end
  end

  def show_meta
    return {} if @user_platform.nil?

    { role: @user_platform.role }
  end
end
