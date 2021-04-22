class AddGenresToRecord < ActiveRecord::Migration
  def change
    add_column :records, :genres, :text
  end
end
