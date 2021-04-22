class AddThumbToRecord < ActiveRecord::Migration
  def change
    add_column :records, :thumb, :text
  end
end
