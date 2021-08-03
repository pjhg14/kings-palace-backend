class Player < ApplicationRecord
  attr_accessor :hand, :table

  def init
    self.hand = []
    self.table = [[],[]]  # [[hidden cards], [showing cards]]
  end
  
end
