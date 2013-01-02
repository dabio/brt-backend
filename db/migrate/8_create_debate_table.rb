migration 8, :create_debates_table do

  up do
    create_table :debates do
      column :id,           Integer, serial: true
      column :title,        String, size: 50
      column :person_id,    Integer
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :debates
  end

end
