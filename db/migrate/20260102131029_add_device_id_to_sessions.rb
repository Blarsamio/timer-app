class AddDeviceIdToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :device_id, :string
  end
end
