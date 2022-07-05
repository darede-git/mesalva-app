# frozen_string_literal: true

module MeSalva
  module User
    class Persona
      def initialize(user)
        @user = user
      end

      def self.update_user_persona_from_typeform_response(form_response)
        user = ::User.find_by_uid(form_response['hidden']['uid'])
        return nil if user.nil?

        instance = new(user)
        instance.update_user_persona_from_typeform_response(form_response)
      end

      def update_user_persona_from_typeform_response(form_response)
        role_slug = role_slug_from_response(form_response['outcome']['title'])
        set_by_slug(role_slug)
      end

      def set_by_slug(role_slug)
        @role = Role.find_by_slug(role_slug)

        return nil if @role.nil?

        onboarding.update(value: { finished: false, accepted: false, current_step: 1 })
        persona_role_ids = Role.where(role_type: 'persona').pluck(:id)
        UserRole.where(user_id: @user.id, role_id: persona_role_ids).delete_all
        UserRole.find_or_create(user_id: @user.id, role_id: @role.id)
      end

      def onboarding
        return @onboarding unless @onboarding.nil?

        @onboarding = UserSetting.where(key: 'onboarding', user: @user).first
        return @onboarding unless @onboarding.nil?

        value = { finished: false, accepted: false, current_step: 0 }
        UserSetting.create(key: 'onboarding', user: @user, value: value)
      end

      def role
        @user.roles.where(role_type: 'persona').first
      end

      def set_from_accesses
        persona_slug = user_has_med_access? ? 'padrao-med' : 'padrao-enem'
        @role = Role.find_by_slug(persona_slug)
        @user.roles << @role

        onboarding.value['current_step'] = 0
        onboarding.save
        @role
      end

      def user_has_med_access?
        @user.accesses.any? do |access|
          access.package.label.include?('medicina-2022-1')
        end
      end

      private

      def role_slug_from_response(title)
        return 'treineiro-med' if title.match?(/TREINEIRO MED/)
        return 'estreante-med' if title.match?(/ESTREANTE MED/)
        return 'agora-vai-med' if title.match?(/AGORA VAI/)
        return 'experiente-med' if title.match?(/EXPERIENTE/)
        return 'perito-med' if title.match?(/PERITO MED/)
        return 'cursinho-plus-med' if title.match?(/CURSINHO PLUS/)
        return 'redacao-na-veia-med' if title.match?(/REDAÇÃO NA VEIA/)
        return 'padrao-med' if title.match?(/PADRÃO MED/)

        return 'treineiro-enem' if title.match?(/TREINEIRO ENEM/)
        return 'terceirao-enem' if title.match?(/TERCEIRÃO/)
        return 'aprendiz-enem' if title.match?(/APRENDIZ/)
        return 'no-ponto-enem' if title.match?(/NO PONTO/)
        return 'flexivel-enem' if title.match?(/FLEXÍVEL/)
        return 'soma-cursinho-enem' if title.match?(/SOMA CURSINHO/)
        return 'redacao-salva-enem' if title.match?(/REDAÇÃO SALVA/)

        'padrao-enem'
      end
    end
  end
end
