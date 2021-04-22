class AddVideosToRecord < ActiveRecord::Migration
  def change
    add_column :records, :videos, :text
  end
end
