migration 3, :create_emails_table do

  up do
    create_table :emails do
      column :id,           Integer, serial: true
      column :name,         String, size: 50
      column :email,        String, size: 50
      column :message,      DataMapper::Property::Text
      column :send_at,      DateTime, allow_nil: true
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :emails
  end

end
