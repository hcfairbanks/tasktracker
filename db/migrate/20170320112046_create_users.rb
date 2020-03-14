class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email,                null: false, default: ''
      t.string :password_digest,      null: false, default: ''
      t.string :first_name
      t.string :last_name
      t.references :role, foreign_key: true
      t.string :avatar

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
  end
end
