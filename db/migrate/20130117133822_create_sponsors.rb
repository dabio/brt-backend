class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string  :title,     null: false
      t.text    :text
      t.string  :image_url, null: false, limit: 2000
      t.string  :url, limit: 2000

      t.timestamps
    end
  end
end
