class AddPricesToRecord < ActiveRecord::Migration
  def change
    add_column :records, :median_price, :decimal
    add_column :records, :high_price, :decimal
  end
end
