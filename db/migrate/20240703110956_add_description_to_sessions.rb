class AddDescriptionToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :description, :text
  end
end
