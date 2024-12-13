class CreateAsanas < ActiveRecord::Migration[7.1]
  def change
    create_table :asanas do |t|
      t.string :title
      t.text :benefits
      t.text :contraindications
      t.text :alternatives_and_options
      t.text :counterposes
      t.text :meridians_and_organs
      t.text :joints
      t.integer :recommended_time
      t.text :other_notes
      t.text :into_pose
      t.text :out_of_pose

      t.timestamps
    end
  end
end
