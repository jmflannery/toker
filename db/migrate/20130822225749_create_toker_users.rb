class CreateTokerUsers < ActiveRecord::Migration
  def change
    create_table :toker_users do |t|
      t.string :email, index: true
      t.string :password_digest

      t.timestamps
    end
  end
end
