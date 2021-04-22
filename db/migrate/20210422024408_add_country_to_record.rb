class AddCountryToRecord < ActiveRecord::Migration
  def change
    add_column :records, :country, :text
  end
end
