class AddPresetToSessions < ActiveRecord::Migration[7.1]
  def up
    add_column :sessions, :preset, :boolean, null: false, default: false
    # Seeded flows are the only sessions without an owning device.
    execute "UPDATE sessions SET preset = TRUE WHERE device_id IS NULL"
  end

  def down
    remove_column :sessions, :preset
  end
end
