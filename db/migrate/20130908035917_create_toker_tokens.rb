class CreateTokerTokens < ActiveRecord::Migration
  def change
    create_table :toker_tokens do |t|
      t.references :user, index: true
      t.string :key, limit: 256
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
