class Record < ActiveRecord::Base
  belongs_to :query
  enum status: [ :unvisited, :visited ]
end
