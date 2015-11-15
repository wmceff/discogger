class Record < ActiveRecord::Base
  enum status: [ :unvisited, :visited ]
end
