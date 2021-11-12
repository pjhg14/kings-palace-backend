class Move < ApplicationRecord
  belongs_to :player
  belongs_to :turn
  
end
