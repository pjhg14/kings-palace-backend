class Player < ApplicationRecord
  attr_accessor :hand, :table

  has_many :moves

  def init
    self.hand = []
    self.table = [[],[]]  # [[hidden cards], [showing cards]]
  end
  
end
