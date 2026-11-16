class AddTimingToAsanas < ActiveRecord::Migration[7.1]
  def up
    add_column :asanas, :min_seconds, :integer
    add_column :asanas, :max_seconds, :integer
    add_column :asanas, :default_seconds, :integer

    Asana.reset_column_information
    Asana.find_each { |asana| asana.update_columns(Asana.timing_for(asana.recommended_time)) }
  end

  def down
    remove_column :asanas, :min_seconds
    remove_column :asanas, :max_seconds
    remove_column :asanas, :default_seconds
  end
end
