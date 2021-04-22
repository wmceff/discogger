class AddArtistsToRecords < ActiveRecord::Migration
  def change
    add_column :records, :artists, :text
  end
end
