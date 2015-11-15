class CreateQueries < ActiveRecord::Migration
  def change
    create_table :queries do |t|
      t.text :query_string
      t.integer :total_pages
      t.integer :completed_page

      t.timestamps
    end
  end
end
