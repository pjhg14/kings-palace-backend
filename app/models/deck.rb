class Deck < ApplicationRecord
  belongs_to :game
  has_many :deck_cards, -> { order(:order)}
end
