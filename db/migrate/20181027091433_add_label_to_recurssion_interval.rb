class AddLabelToRecurssionInterval < ActiveRecord::Migration[5.1]
  def change
    add_column :recurssion_intervals, :label, :string
  end
end
