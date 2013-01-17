class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name, null: false, limit: 50
      t.string :last_name,  null: false, limit: 50
      t.string :slug,       limit: 101
      t.string :email
      t.string :password,   limit: 60
      t.text :info
      t.boolean :is_admin,  default: false

      t.timestamps
    end
  end
end
