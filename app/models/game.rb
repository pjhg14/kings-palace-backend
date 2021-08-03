class Game < ApplicationRecord
  attr_accessor :deck, :discard, :player_iterator

  SUITS = ["Spade", "Club", "Heart","Diamond"]
  VALUES = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "0", "J", "Q", "K"]

  def init
    self.deck = self.create_deck.shuffle
    self.discard = []
  end

  def start
    # Initialize player virtual fields (Hand & Table)
    self.players.each do |player|
      player.init
    end

    # Give appropriate cards to current players
    self.deal
    
    # At this point allow players to swap out cards from hand to face up table [1] (Might be a todo)

    self.player_iterator = self.players.to_enum
  end

  # def finish
  #   # assume current player is winner
  #   self.current_player.user.wins += 1

  #   self.moves.destroy_all
  #   self.players.destroy_all
  #   self.destroy
  # end
  
  def penalty
    # If current player was not able to play any cards, move discard to their hand
    self.current_player.hand.push(self.discard).flatten
    self.discard = []
  end
  

  def iterate_players
    self.player_iterator.next

    # test iterated player.is_ai = true
    if self.player_iterator.peek.is_ai
      # if true, do ai move
      self.ai_move
    end

    # then iterate again
    self.player_iterator.next

  rescue StopIteration
    self.player_iterator = self.players.to_enum

  end
  
  def current_player
    self.player_iterator.peek
    
  rescue StopIteration
    self.player_iterator = self.players.to_enum
    self.player_iterator.peek
  end

  # Current player picks up top card from deck
  def pickup()
    player = self.current_player

    player.hand.push(self.deck.pop)
  end
  
  # plays the current card, returns false if card was played, returns true when no more cards sould be played
  def play_card(card, from)
    player = self.current_player

    # remove card(s) from player and puts it in the discard pile
    case from
    when "hand"
      card_index = player.hand.find_index {|hand_card| card.code == hand_card.code}
      self.discard.push(player.hand.delete_at(card_index))
    when "table_shown"
      card_index = player.table[1].find_index {|table_card| card.code == table_card.code}
      self.discard.push(player.table[1].delete_at(card_index))
    when "table_hidden"
      card_index = player.table[0].find_index {|table_card| card.code == table_card.code}
      self.discard.push(player.table[0].delete_at(card_index))
    else # ???
      # ummmm...
    end

  end

  def ai_move
    ai_player = self.current_player
    # ai move
    # select random card
    # remove card(s) from player
    # add card(s) to discard pile

    if !ai_player.hand.empty?
      card = ai_player.hand.sample
      card_index = ai_player.hand.find_index {|hand_card| card.code == hand_card.code}
      self.discard.push(ai_player.hand.delete_at(card_index))

    elsif !ai_player.table[1].empty?
      card = ai_player.table[1].sample
      card_index = ai_player.table[1].find_index {|table_card| card.code == table_card.code}
      self.discard.push(ai_player.table[1].delete_at(card_index))

    elsif !ai_player.table[0].empty?
      card = ai_player.table[0].sample
      card_index = ai_player.table[0].find_index {|table_card| card.code == table_card.code}
      self.discard.push(ai_player.table[0].delete_at(card_index))
    else
      ai_player.has_won = true
    end
      
    # if player.hand.length < 3 & deck is not empty, draw cards until hand.length = 3
    if !self.deck.empty?
      while player.hand.length < 3
        self.pickup()
      end
    end
  end
  
  def deal
    # deal face down cards
    self.players.each do |player|
      3.times do
        player.table[0].push(self.deck.pop )
      end
    end

    # deal face up cards
    self.players.each do |player|
      3.times do
        player.table[1].push(self.deck.pop )
      end
    end
    
    # deal hands
    3.times do
      self.players.each do |player|
        player.hand.push(self.deck.pop)
      end
    end
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
  
end
