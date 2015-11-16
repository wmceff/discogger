class AddQueryToRecord < ActiveRecord::Migration
  def change
    add_reference :records, :query, index: true, foreign_key: true
  end
end
