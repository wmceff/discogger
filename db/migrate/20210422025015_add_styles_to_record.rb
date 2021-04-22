class AddStylesToRecord < ActiveRecord::Migration
  def change
    add_column :records, :styles, :text
  end
end
