class AddSimilarYangAsanasToAsanasAsText < ActiveRecord::Migration[7.1]
  def change
    add_column :asanas, :similar_yang_asanas, :text
  end
end
