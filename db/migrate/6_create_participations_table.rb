migration 6, :create_participations_table do

  up do
    create_table :participations, {key: [:event_id, :person_id]} do
      column :event_id,             Integer
      column :person_id,            Integer
      column :position_overall,     Integer, unique: true
      column :position_age_class,   Integer, unique: true
      column :date,                 DateTime
      column :created_at,           DateTime
      column :updated_at,           DateTime
    end
  end

  down do
    drop_table :participations
  end

end
