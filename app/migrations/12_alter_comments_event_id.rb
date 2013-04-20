migration 12, :alter_comments_event_id do

  up do
    modify_table :comments do
      add_column :event_id, Integer, allow_nil: true
    end
  end

  down do
    modify_table :comments do
      drop_column :event_id
    end
  end

end
