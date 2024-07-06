class AddTitleToTimer < ActiveRecord::Migration[7.1]
  def change
    add_column :timers, :title, :string
  end
end
