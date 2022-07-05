# frozen_string_literal: true

module MeSalva
  module Crm
    module Rdstation
      module Event
        class PrepTest
          def initialize(**params)
            @user = params[:user]
            @node_module = params[:node_module]
            @item = params[:item]
            @submission_token = params[:submission_token]
          end

          def answer
            Client.new({ user: @user,
                         event_name: answer_name,
                         payload: answer_attributes })
                  .create
          end

          private

          def answer_name
            "prep_test_answer|#{@node_module.slug}"
          end

          def answer_attributes
            { cf_submission_token: @submission_token,
              cf_node_module_name: @node_module.name,
              cf_item_name: @item.name }
          end
        end
      end
    end
  end
end
