migration 14, :alter_people_is_active do

  up do
    modify_table :people do
      add_column :is_active, TrueClass, default: true
    end
  end

  down do
    modify_table :people do
      drop_column :is_active
    end
  end

end
