class CreateApiKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :api_keys do |t|
      t.string :name
      t.string :key_digest
      t.boolean :active
      t.datetime :expires_at

      t.timestamps
    end
  end
end
