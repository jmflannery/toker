class CreateTokeTokens < ActiveRecord::Migration
  def change
    create_table :toke_tokens do |t|
      t.string :key
      t.references :user, index: true
      t.datetime :expires_at

      t.timestamps
    end
    add_index :toke_tokens, :key, unique: true
  end
end
