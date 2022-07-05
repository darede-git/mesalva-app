# frozen_string_literal: true

class ChangePrepTestDetailsTypeName < ActiveRecord::Migration[5.2]
    def change
      rename_column :prep_test_details, :type, :suggestion_type
    end
end
