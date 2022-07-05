# frozen_string_literal: true

module MeSalva
  module PrepTest
    class PrepTestCache
      def initialize(submission_token)
        @details = { ms_wrongs: {}, enem_wrongs: {}, enem_corrects: {} }
        @corrects_count = 0
        @submission_token = submission_token
      end

      def add(permalink, correct)
        @permalink = permalink
        @correct = correct
        @corrects_count += @correct ? 1 : 0
        update_ms_details
        update_enem_details
      end

      def save(meta, user_uid)
        return if @permalink.nil?

        remove_duplicated_enem_details
        PrepTestOverviewWorker.perform_async(
          score: meta[:score],
          answers: meta[:answers],
          token: @submission_token,
          user_uid: user_uid,
          permalink_slug: permalink_node_module_slug,
          corrects: @corrects_count
        )
        PrepTestDetailWorker.perform_async(details_to_array)
      end

      private

      def permalink_node_module_slug
        @permalink.slug.gsub("/#{@permalink.medium.slug}", '')
      end

      def remove_duplicated_enem_details
        @details[:enem_corrects].each_key do |n|
          @details[:enem_wrongs].delete(n) if @details[:enem_wrongs].key?(n)
        end
      end

      def details_to_array
        detail_hints = @details.values.map do |detail_type|
          detail_type.values.flatten
        end
        detail_hints.flatten
      end

      def update_ms_details
        return nil if @correct

        update_detail(@permalink.medium.options['label'], :ms_wrongs)
      end

      def update_enem_details
        token = "#{@permalink.medium.options['ability']}-#{@permalink.medium.options['competence']}"
        key = @correct ? :enem_corrects : :enem_wrongs
        update_detail(token, key)
      end

      def update_detail(token, key)
        options = @permalink.medium.options
        if @details[key][token]
          @details[key][token][:options][:modules] = mount_modules(options, @details[key][token][:options][:modules])
          return @details[key][token][:weight] += 1
        end

        @details[key][token] = {
          "options": {
            "label": options['label'],
            "permalink": options['permalink'],
            "ability": options['ability'],
            "competence": options['competence'],
            "abilityDescription": options['abilityDescription'],
            "modules": mount_modules(options, {}),
            "competenceDescription": options['competenceDescription'],
          },
          "suggestion_type": key.to_s,
          "token": @submission_token,
          "weight": 1
        }
      end

      def mount_modules(options, modules = {})
        return modules unless options['moduleName']
        key = options['moduleName'].gsub(/ /, '')
        if modules[key]
          modules[key][:weight] += 1
          return modules
        end
        modules[key] = {
          "permalink": options['permalink'],
          "name": options['moduleName'],
          "weight": 1
        }
        modules
      end
    end
  end
end
