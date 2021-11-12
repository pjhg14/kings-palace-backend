class Game < ApplicationRecord
  # Relations ------------------------------------------------------------------------------------/
  has_many :players, dependant: destroy_all
  has_many :turns, dependant: destroy_all
  # ----------------------------------------------------------------------------------------------/

  # Constants ------------------------------------------------------------------------------------/
  SUITS = ["Spade", "Club", "Heart","Diamond"]
  VALUES = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "0", "J", "Q", "K"]
  VALUE_MAP ={
    "2": 99,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    "10": 10,
    "J": 11,
    "K": 12,
    "Q": 13,
    "A": 14,
  }
  # ----------------------------------------------------------------------------------------------/

  # Game initialize method
  def init
    self.deck = self.create_deck.shuffle
    self.discard = []
  end

  def start
    # Initialize player virtual fields (Hand & Table)

    # Give appropriate cards to current players

    # Place card on discard from top of deck
    
    # At this point allow players to swap out cards from hand to face up table [1] (Might be a todo)
  end

  def finish
    # clean-up
  end
  
  def penalty
    # If current player was not able to play any cards, move discard to their hand
  end
  

  def iterate_players
    
  end
  
  def current_player
    
  end

  def pickup()
    # Current player picks up top card from deck
  end
  
  def play_card(card, from)
    # plays the current card, returns false if card was played, returns true when no more cards sould be played
    # remove card(s) from player and puts it in the discard pile
  end

  def ai_move
    ai_player = self.current_player

    # ai move
    # select card
    # check if card can be played
    # remove card(s) from player
    # add card(s) to discard pile    

  end
  
  def deal
    # deal face down cards

    # deal face up cards
    
    # deal hands
    
  end

  def number_of_cards
    self.deck.length
  end

  def create_deck
    SUITS.map do |suit|
      VALUES.map do |value| 
        case value
        when "A"
          full_value = "Ace"
        when "0"
          full_value = "10"
        when "J"
          full_value = "Jack"
        when "Q"
          full_value = "Queen"
        when "K"
          full_value = "King"
        else
          full_value = value
        end

        # Return card hash
        { suit: suit, value: value, code: suit[0] + value, full_value: full_value } 
      end.flatten
    end
  end

  def self.generate_code
    ('A'..'Z').to_a.sample(4).join
  end

  def can_play?(played_card, dis_card)
    VALUE_MAP[played_card.value] >= VALUE_MAP[dis_card.value]
  end
  
end
