migration 14, :alter_events_is_hidden do

  up do
    modify_table :events do
      add_column :is_hidden, TrueClass, default: false
    end
  end

  down do
    modify_table :events do
      drop_column :is_hidden
    end
  end

end
