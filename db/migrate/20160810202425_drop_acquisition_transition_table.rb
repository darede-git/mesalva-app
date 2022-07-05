class DropAcquisitionTransitionTable < ActiveRecord::Migration[4.2]
  def change
    drop_table :acquisition_transitions
  end
end
