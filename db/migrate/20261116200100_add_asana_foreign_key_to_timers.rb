class AddAsanaForeignKeyToTimers < ActiveRecord::Migration[7.1]
  def up
    # Clear dangling ids first, or the FK can't be added.
    execute "UPDATE timers SET asana_id = NULL WHERE asana_id IS NOT NULL AND asana_id NOT IN (SELECT id FROM asanas)"
    add_foreign_key :timers, :asanas, on_delete: :nullify

    # Link existing timers by title (Timer#link_asana runs on save).
    Timer.reset_column_information
    Timer.where(asana_id: nil).where.not(title: [nil, ""]).find_each(&:save!)
  end

  def down
    remove_foreign_key :timers, :asanas
  end
end
