migration 2, :create_news_table do

  up do
    create_table :news do
      column :id,           Integer, serial: true
      column :date,         DateTime
      column :title,        String, size: 250
      column :teaser,       DataMapper::Property::Text
      column :message,      DataMapper::Property::Text
      column :slug,         String, size: 250
      column :created_at,   DateTime
      column :updated_at,   DateTime
      column :event_id,     Integer, allow_nil: true
      column :person_id,    Integer
    end
  end

  down do
    drop_table :news
  end

end
