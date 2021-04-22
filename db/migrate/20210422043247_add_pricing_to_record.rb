class AddPricingToRecord < ActiveRecord::Migration
  def change
    add_column :records, :pricing, :text
  end
end
