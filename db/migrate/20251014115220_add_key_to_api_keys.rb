class AddKeyToApiKeys < ActiveRecord::Migration[7.1]
  def change
    add_column :api_keys, :key, :string
  end
end
