# frozen_string_literal: true

module Bff
  module Templates
    module StudyPlans
      class StudyPlanContent
        def initialize(user)
          @user = user
        end

        def fetch_study_plan
          @study_plan = StudyPlan.active
                                 .order('created_at DESC')
                                 .find_by_user_id(@user.id)
        end

        def empty_study_plan
          DesignSystem::Grid.render(
            columns: { md: [1] },
            children: [
              DesignSystem::SectionCard.render(
                class_name: "text-center",
                children: [
                  DesignSystem::Title.render(
                    children: "Configure seu plano de estudos!"
                  ),
                  DesignSystem::Grid.render(
                    class_name: "my-xl",
                    columns: { sm: 3 },
                    children: [
                      DesignSystem::Grid.render(
                        class_name: "p-lg",
                        children: [
                          DesignSystem::Image.render(
                            height: 160,
                            className: "mx-auto image-to-dark-mode",
                            src: "https://cdn.mesalva.com/uploads/image/MjAyMS0wNC0wOCAxMjo0NzozNSArMDAwMDMyNzk2Nw%3D%3D%0A.png"
                          ),
                          DesignSystem::Title.render(
                            level: 3,
                            variant: :subtitle,
                            size: :md,
                            children: "Escolha matérias"
                          ),
                          DesignSystem::Text.render(
                            size: :sm,
                            children: "Selecione todas as matérias que você precisa estudar para mandar bem."
                          )
                        ]
                      ),
                      DesignSystem::Grid.render(
                        class_name: "p-lg",
                        children: [
                          DesignSystem::Image.render(
                            height: 160,
                            class_name: "mx-auto image-to-dark-mode",
                            src: "https://cdn.mesalva.com/uploads/image/MjAyMS0wNC0wOCAxMjo0ODowMSArMDAwMDQzNTQ2MQ%3D%3D%0A.png"
                          ),
                          DesignSystem::Title.render(level: 3,
                                                     variant: "subtitle",
                                                     size: "md",
                                                     className: "text-strong",
                                                     children: "Marque a disponibilidade"),
                          DesignSystem::Text.render(size: :sm,
                                                    children: "Escolha os dias da semana e os turnos nos quais você tem disponibilidade.")
                        ]
                      ),
                      DesignSystem::Grid.render(
                        class_name: "p-lg",
                        children: [
                          DesignSystem::Image.render(height: 160,
                                                     class_name: "mx-auto image-to-dark-mode",
                                                     src: "https://cdn.mesalva.com/uploads/image/MjAyMS0wNC0wOCAxMjo0ODoxMiArMDAwMDI1NDUwOQ%3D%3D%0A.png"),
                          DesignSystem::Title.render(
                            level: 3,
                            variant: :subtitle,
                            size: :md,
                            children: "Recalcule quando quiser"
                          ),
                          DesignSystem::Text.render(size: :sm,
                                                    children: "Se a sua rotina ou necessidade de conteúdo mudar, é só atualizar o plano.")
                        ]
                      ),
                      DesignSystem::Button.render(children: "Configurar o meu plano",
                                                  href: "https://www.mesalva.com/enem-e-vestibulares/novo-plano")
                    ]
                  )
                ]
              )
            ])
        end

        def fetch_contents(page)
          @page_number = (page || 1).to_i
          if @page_number >= 1
            @item_offset = @study_plan.offset || 1
            page_offset = (@page_number - 1) * @study_plan.limit
            @item_offset += page_offset
            @contents = @study_plan.node_modules
                                   .select("node_modules.*, study_plan_node_modules.completed")
                                   .order('study_plan_node_modules.position')
                                   .offset(@study_plan.offset + page_offset)
                                   .limit(@study_plan.limit)
          else
            page_offset = @page_number * @study_plan.limit
            offset = @study_plan.offset + page_offset
            offset = 0 if offset < 0
            @item_offset = offset
            limit = @study_plan.limit
            limit = @study_plan.offset if limit > @study_plan.offset
            @contents = @study_plan.node_modules
                                   .select("node_modules.*, study_plan_node_modules.completed")
                                   .order('study_plan_node_modules.position')
                                   .offset(offset)
                                   .limit(limit)
          end
          mount_shifts
        end

        def events
          events = []
          @contents.each do |content|
            events << content.id.to_s if content.completed
          end
          events
        end

        def render
          mount_section
          { children: [
            study_plan_content_card,
            study_plan_config_card
          ] }
        end

        private

        def study_plan_config_card
          grid = DesignSystem::Grid.render(children: [
            DesignSystem::Text.render(
              children: 'Se quiser alterar seu plano, clique em "Recalcular". Já se quiser desativá-lo por qualquer motivo, clique em "Desativar".'
            ),
            DesignSystem::DisableStudyPlanButton.render(
              size: "sm",
              variant: "secondary",
              label: "Desativar",
              studyPlanId: @study_plan.id
            ),
            DesignSystem::Button.render(href: "https://www.mesalva.com/enem-e-vestibulares/novo-plano",
                                        size: :sm,
                                        children: "Recalcular")
          ])
          DesignSystem::SectionCard.render(title: "Configure seu plano de estudos!", children: [grid])
        end

        def study_plan_content_card
          DesignSystem::SectionCard.render(children: @children)
        end

        def previous_navigation
          return { disabled: true } if @page_number == 1 && @study_plan.offset <= 1

          return { href: "/app/plano-de-estudos" } if @page_number == 2
          return { href: "/app/plano-de-estudos?page=#{@page_number - 2}" } if @page_number <= 1

          { href: "/app/plano-de-estudos?page=#{@page_number - 1}" }
        end

        def total_pages
          return 1 if @study_plan.limit.zero?

          (@study_plan.node_modules_count / @study_plan.limit.to_f).ceil
        end

        def next_navigation
          return { disabled: true } if @page_number >= total_pages
          return { href: "/app/plano-de-estudos" } if @page_number == -1

          { href: "/app/plano-de-estudos?page=#{@page_number + 1}" }
        end

        def navigation_title
          return "Conteúdos de semanas anteriores" if @page_number < 1
          return "Conteúdos das próximas semanas" if @page_number > 1

          "Conteúdos para esta semana"
        end

        def group_navigation(list)
          title = @page_number == 1 ? "Conteúdos para esta semana" : "Conteúdos de outras semanas"
          {
            "component": "GroupNavigation",
            "title": title,
            "targetId": "programacao-da-semana",
            "previous": previous_navigation,
            "next": next_navigation,
            "list": list
          }
        end

        def mount_shifts
          @shifts = shifts_to_days
        end

        def shifts_to_days
          max_shifts = @study_plan.shifts.count
          days_with_shifts = {}
          @study_plan.shifts.each do |day|
            key = day.keys.first
            days_with_shifts[key] ||= []
            days_with_shifts[key] << day.values.first
          end
          days_with_shifts = days_with_shifts.sort do |day1, day2|
            day1.first > day2.first ? 1 : -1
          end
          days = []
          max_weight = 0
          days_with_shifts.each do |day, values|
            shifts_count = values.count.to_f
            shifts = shifts_count > 1 ? "shifts_#{values.count}" : values.first
            active = day.to_i == MeSalva::DateHelper.now_with_offset.wday && @page_number == 1
            weight = shifts_count * @study_plan.limit / max_shifts
            max_weight += weight.floor
            days << {
              shifts: shifts_count.floor,
              weight: weight,
              short_name: MeSalva::DateHelper.wday_name_by_index(day, true),
              full_name: MeSalva::DateHelper.wday_name_by_index(day),
              subtitle: I18n.t("date.shifts.#{shifts}"),
              active: active
            }
          end
          rest = @study_plan.limit - max_weight
          max_shifts
          additional = (rest.to_f/days.count).ceil
          days.each do |day|
            if rest.zero?
              day[:weight] = day[:weight].floor
            elsif additional > rest
              rest = 0
              day[:weight] += rest
              day[:weight] = day[:weight].floor
            else
              rest -= additional
              day[:weight] += additional
              day[:weight] = day[:weight].floor
            end
          end
          days
        end

        def near_navigation
          @shifts.map do |day|
            {
              "title": day[:short_name],
              "subtitle": day[:subtitle],
              "active": day[:active],
              "disabled": false,
              "href": "#dia-#{day[:short_name].downcase}"
            }
          end
        end

        def contents_by_shift
          day_component = []
          day_list = []
          day_index = 0
          item_index = 0
          @contents.each do |content|
            @item_offset += 1
            if day_component[day_index].nil?
              day_component[day_index] = create_day_accordeon(day_index)
              day_list[day_index] = []
            end
            area_name = Contents::ContentSubject.simplified_name(content.nodes.first.parent.parent.parent.name)
            subject_name = Contents::ContentSubject.simplified_name(content.nodes.first.parent.parent.name)
            day_list[day_index] << {
              "icon": { "name": "video" },
              "overline": @item_offset.to_s.rjust(3, '0'),
              "title": content.name,
              "checked": content.completed,
              "id": content.id.to_s,
              "link": { "href": "https://www.mesalva.com/#{study_plan_module_permalink_slug(content)}?theme=plano-de-estudos" },
              "labels": [
                { "children": subject_name, "theme": "subject", "variant": Contents::ContentSubject.label_variant(area_name) }
              ]
            }
            item_index_limit = @shifts[day_index][:weight]
            item_index += 1
            if item_index >= item_index_limit.to_i && @page_number >= 1 && item_index_limit.to_i && @shifts[day_index + 1].present?
              day_index += 1
              item_index = 0
            end
          end
          day_component.each_with_index do |day, index|
            day[:children].first[:list] = day_list[index]
          end
          day_component
        end

        def study_plan_module_permalink_slug(node_module)
          node_module.permalinks
                     .where("item_id IS NULL AND slug LIKE 'enem-e-vestibulares/materias/%'").first&.slug
        end

        def create_day_accordeon(day_index)
          shift = @shifts[day_index]
          title = @page_number >= 1 ? shift[:full_name] : 'Módulos anteriores'
          active = @page_number >= 1 ? shift[:active] : true
          {
            "component": "Accordion",
            "id": "dia-#{shift[:short_name].downcase}",
            "title": title,
            "active": shift[:active],
            "default_open": active,
            "children": [{ "component": "ComponentList", "emptyMessage": "Nenhuma aula ao vivo para esse dia" }],
            "list": []
          }
        end

        def mount_section
          @children = []
          @children << group_navigation(near_navigation)
          @children << {
            "component": "ComponentTodoList",
            "is_editable": true,
            "event_slug": "study_plans",
            "children": contents_by_shift
          }
          @children
        end
      end
    end
  end
end
