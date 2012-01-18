migration 5, :create_visits_table do

  up do
    create_table :visits do
      column :person_id,    Integer, serial: true
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :visits
  end

end
