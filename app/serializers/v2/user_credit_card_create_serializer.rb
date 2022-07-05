# frozen_string_literal: true

class V2::UserCreditCardCreateSerializer < V2::ApplicationSerializer
  attribute :valid

  set_id :id
end
