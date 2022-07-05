# frozen_string_literal: true

class Bff::User::ProfilesController < Bff::User::BffUserBaseController
  def full
    render_results({ user: full_user, accesses: accesses })
  end

  private

  def full_user
    {
      name: current_user.name,
      email: user_email,
      uid: current_user.uid,
      token: current_user.token,
      birth_date: current_user.birth_date,
      phone: current_user.phone,
      image: user_image,
      enem_subscription_id: current_user.enem_subscription_id,
      roles: user_roles,
      persona: persona,
      settings: current_user.settings,
      guest: false
    }
  end

  def user_email
    current_user.crm_email || current_user.email
  end

  def user_image
    current_user.image.nil? ? nil : current_user.image.url
  end

  def accesses
    return @accesses unless @accesses.nil?

    @accesses = {
      onboarding_pending: onboarding_not_finished?
    }
    @user_feature_ids = []

    add_accesses_attributes
    add_each_feature_to_accesses

    @accesses
  end

  def user_roles
    current_user.roles.where("role_type != 'persona'").map { |role| { name: role.name, slug: role.slug } }
  end

  def persona
    persona = MeSalva::User::Persona.new(current_user)
    @user_persona = persona.role
    @user_persona = persona.set_from_accesses if @user_persona.nil?

    {
      name: @user_persona.name,
      slug: @user_persona.slug,
      brand_image: persona_brand_image
    }
  end

  def onboarding
    @onboarding ||= MeSalva::User::Persona.new(current_user).onboarding
  end

  def onboarding_not_finished?
    onboarding.value['finished'] != true
  end

  def persona_brand_image
    return nil unless @user_persona.slug.match?(/-med$/)

    "https://cdn.mesalva.com/uploads/image/MjAyMi0wNi0yNCAxNzoyMzo0NyArMDAwMDEyOTUyMA%3D%3D%0A.svg"
  end

  def user_has_med_access?
    current_user.accesses.any? do |access|
      access.package.label.include?('medicina-2022-1')
    end
  end

  def default_persona
    { name: 'Padrão ENEM', slug: 'padrao-enem' }
  end

  def add_accesses_attributes
    set_user_accesses
    threat_accesses

    @accesses['has'] = any_access?
    @accesses['role_slugs'] = user_roles.map { |role| role[:slug] }
    @accesses['course_class'] = any_couse_class?
    @accesses['course_class_labels'] = @course_class_labels.uniq
    @accesses['remaining_days'] = @remaining_days
    @accesses['essay_credits'] = @essay_credits
    @accesses['essay'] = essay?
    @accesses['essay_unlimited'] = @unlimited_essay_credits
  end

  def set_user_accesses
    @user_accesses = Access.by_user_active_in_range(current_user.id)

    @remaining_days = 0
    @essay_credits = 0
    @unlimited_essay_credits = false
    @course_class_labels = []
  end

  def threat_accesses
    @user_accesses.each { |access| threat_access(access) }
  end

  def essay?
    @unlimited_essay_credits || @essay_credits.positive?
  end

  def any_access?
    @user_accesses.count.positive?
  end

  def any_couse_class?
    @course_class_labels.length.positive?
  end

  def threat_access(access)
    @course_class_labels.concat(access.package.label)

    current_remaining_days = access.full_remaining_days.to_i
    @remaining_days = current_remaining_days if current_remaining_days > @remaining_days
    @essay_credits += access.package.essay_credits
    @unlimited_essay_credits ||= access.package.unlimited_essay_credits

    @user_feature_ids.concat(access.package.feature_ids)
  end

  def add_each_feature_to_accesses
    Feature.all.each do |feature|
      key = feature.category ? "#{feature.category}_#{feature.token}" : feature.token
      @accesses[key] = @user_feature_ids.include?(feature.id)
    end
  end
end
