class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.float :rating
      t.integer :count
      t.integer :want
      t.integer :discogs_id
      t.string :title
      t.string :uri

      t.timestamps
    end
  end
end
