class ChangeColumnTypeInAsanaTable < ActiveRecord::Migration[7.1]
  def change
    change_column :asanas, :recommended_time, :string
  end
end
