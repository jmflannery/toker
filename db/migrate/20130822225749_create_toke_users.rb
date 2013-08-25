class CreateTokeUsers < ActiveRecord::Migration
  def change
    create_table :toke_users do |t|
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
