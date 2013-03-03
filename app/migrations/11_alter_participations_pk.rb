migration 11, :alter_participation_pk do

  up do
    modify_table :participations do
      add_column :id, Integer, serial: true
    end
  end

  down do
    modify_table :participation do
      drop_column :id
    end
  end

end
