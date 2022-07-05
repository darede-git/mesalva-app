# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class StudyObjective
          def initialize(**params)
            @user = params[:user]
            @objective_id = params[:objective_id]
          end

          def change
            Client.new({ user: @user,
                         event_name: 'mudanca-de-objetivo-de-estudos',
                         payload: study_objective_change_attributes }).create
          end

          private

          def study_objective_change_attributes
            { cf_objetivo_de_estudos: objective }
          end

          def objective
            case @objective_id
            when 2
              "Reforço Escolar para o Ensino Médio"
            when 4
              "Preparação para o ENEM e Vestibulares"
            when 7
              "Reforço Universitário de Engenharia"
            when 8
              "Reforço Universitário de Ciências da Saúde"
            when 9
              "Reforço Universitário de Negócios"
            else
              objective = Objective.find(@objective_id)
              objective.name
            end
          end
        end
      end
    end
  end
end
