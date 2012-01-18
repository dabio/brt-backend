migration 4, :create_events_table do

  up do
    create_table :events do
      column :id,           Integer, serial: true
      column :date,         DateTime
      column :title,        String, size: 250
      column :slug,         String, size: 250
      column :url,          String, size: 2000
      column :distance,     Integer
      column :type,         Integer, default: 1
      column :person_id,    Integer
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :events
  end

end
