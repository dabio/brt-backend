migration 7, :create_comments_table do

  up do
    create_table :comments do
      column :id,           Integer, serial: true
      column :text,         DataMapper::Property::Text
      column :person_id,    Integer
      column :debate_id,    Integer, allow_nil: true
      column :news_id,      Integer, allow_nil: true
      column :created_at,   DateTime
      column :updated_at,   DateTime
    end
  end

  down do
    drop_table :comments
  end

end
