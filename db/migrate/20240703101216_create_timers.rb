class CreateTimers < ActiveRecord::Migration[7.1]
  def change
    create_table :timers do |t|
      t.integer :duration
      t.references :session, null: false, foreign_key: true

      t.timestamps
    end
  end
end
