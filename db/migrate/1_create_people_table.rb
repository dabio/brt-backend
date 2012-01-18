migration 1, :create_people_table do

  up do
    create_table :people do
      column :id,           Integer, serial: true
      column :first_name,   String, size: 50
      column :last_name,    String, size: 50
      column :slug,         String, size: 101
      column :email,        String, size: 255
      column :password,     String, size: 60
      column :info,         DataMapper::Property::Text
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :people
  end

end
