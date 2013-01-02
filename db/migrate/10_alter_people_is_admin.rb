migration 10, :alter_people_is_admin do

  up do
    modify_table :people do
      add_column :is_admin, TrueClass, default: false
    end
  end

  down do
    modify_table :people do
      drop_column :is_admin
    end
  end

end
