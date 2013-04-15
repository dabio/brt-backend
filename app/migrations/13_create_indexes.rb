migration 13, :create_indexes do

  up do
    create_index :people, :slug, unique: true

    create_index :events, :date
    create_index :events, :slug

    create_index :news, :date
    create_index :news, :slug
    create_index :news, :event_id

    create_index :participations, :person_id
    create_index :participations, :event_id
    create_index :participations, :date
  end

end

