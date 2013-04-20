migration 9, :create_sponsors_table do

  up do
    create_table :sponsors do
      column :id,           Integer, serial: true
      column :title,        String, size: 50
      column :text,         DataMapper::Property::Text
      column :image_url,    String, size: 2000
      column :url,          String, size: 2000
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :sponsors
  end

end
