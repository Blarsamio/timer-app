class AddSessionToAsanas < ActiveRecord::Migration[7.1]
  def change
    add_reference :asanas, :session, foreign_key: true
  end
end
