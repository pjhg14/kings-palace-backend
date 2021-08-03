class Game < ApplicationRecord
  attr_accessor :deck, :discard, :player_iterator

  has_many :players
  has_many :moves

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
    self.can_join = false
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
    self.discard.clear

    self.iterate_players
  end
  

  def iterate_players
    self.player_iterator.next
    self.turn += 1

    # test iterated player.is_ai = true
    if self.player_iterator.peek.is_ai
      # if true, do ai move
      reset = self.ai_move

      # if ai plays a 2 it goes again until it does not 
      while reset
        reset = self.ai_move
      end
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
      card_index = player.hand.find_index {|hand_card| card == hand_card.code}
      self.discard.push(player.hand.delete_at(card_index))
    when "table_shown"
      card_index = player.table[1].find_index {|table_card| card == table_card.code}
      self.discard.push(player.table[1].delete_at(card_index))
    when "table_hidden"
      card_index = player.table[0].find_index {|table_card| card == table_card.code}
      self.discard.push(player.table[0].delete_at(card_index))
    else # ???
      # ummmm...
    end
    
    # Needs logic to avoid dead theoretical dead games
    # if card.value == "10"
    #   discard.clear
    # end
    
    card.value == "2" # || card.value == "10"

  end

  def ai_move
    ai_player = self.current_player

    # ai move
    # select card
    # check if card can be played
    # remove card(s) from player
    # add card(s) to discard pile    

    if !ai_player.hand.empty?
      cant_place = true

      ai_player.hand.each do |card|
        if can_play?(card.value, self.deck.peek)
          Move.create(game: self, player: ai_player, data{played_cards: [card], from: "hand"})

          card_index = ai_player.hand.find_index {|hand_card| card.code == hand_card.code}
          self.discard.push(ai_player.hand.delete_at(card_index))

          cant_place = false
        end
      end
      
      if cant_place
        penalty()
      end

    elsif !ai_player.table[1].empty?
      cant_place = true

      ai_player.hand.each do |card|
        if can_play?(card.value, self.deck.peek)
          Move.create(game: self, player: ai_player, data{played_cards: [card], from: "table_shown"})

          card_index = ai_player.table[1].find_index {|table_card| card.code == table_card.code}
          self.discard.push(ai_player.table[1].delete_at(card_index))

          cant_place = false
        end
      end
      
      if cant_place
        penalty()
      end

    elsif !ai_player.table[0].empty?
      cant_place = true

      ai_player.hand.each do |card|
        if can_play?(card.value, self.deck.peek)
          Move.create(game: self, player: ai_player, data{played_cards: [card], from: "table_hidden"})

          card_index = ai_player.table[0].find_index {|table_card| card.code == table_card.code}
      self.discard.push(ai_player.table[0].delete_at(card_index))

          cant_place = false
        end
      end
      
      if cant_place
        penalty()
      end

    else
      self.is_done = true
      ai_player.has_won = true
      return
    end
      
    # if player.hand.length < 3 & deck is not empty, draw cards until hand.length = 3
    if !self.deck.empty?
      while player.hand.length < 3
        self.pickup()
      end
    end

    # if ai played a 2 return true otherwise return false
    card.value == "2"
  end
  
  def deal
    # deal face down cards
    self.players.each do |player|
      3.times do
        player.table[0].push(self.deck.pop)
      end
    end

    # deal face up cards
    self.players.each do |player|
      3.times do
        player.table[1].push(self.deck.pop)
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

  def can_play?(played_card, dis_card)
    VALUE_MAP[played_card.value] >= VALUE_MAP[dis_card.value]
  end
  
  
end
