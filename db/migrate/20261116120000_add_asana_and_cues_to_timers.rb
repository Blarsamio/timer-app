class AddAsanaAndCuesToTimers < ActiveRecord::Migration[7.1]
  def change
    add_reference :timers, :asana, null: true, index: true
    add_column :timers, :instruction, :string
    add_column :timers, :counterpose, :string
  end
end
