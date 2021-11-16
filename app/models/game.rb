class Game < ApplicationRecord
  # Relations ------------------------------------------------------------------------------------/
  has_one :deck, dependant: destroy_all
  has_one :discard, dependant: destroy_all
  has_many :players, dependant: destroy_all
  has_many :turns, dependant: destroy_all
  # ----------------------------------------------------------------------------------------------/

  # Game initialize method
  def init
    # create card related fields
    # create deck
    deck = Deck.create(game: self)

    card_indexes = (1..52).to_a

    # Join cards to deck
    Card.all.each do |card|
      index = card_indexes.sample

      DeckCard.create(deck: deck, card: card, order: index)

      card_indexes.delete(index)
    end
    
    # create discard
    Discard.create(game: self)
  end

  def start_swaps
    # Initialize player virtual fields (Hand & Table)
    self.players.each do |player|
      # create hand

      # create table

      # deal cards
    end
    
    # At this point allow players to swap out cards from hand to face up table [1]
    self.swap_phase = true
  end
  

  def start
    # Place card on discard from top of deck
    # get card from top of deck
    card = self.deck.deck_cards.last.card

    # add card to discard pile
    DiscardCard.create(discard: self.discard, card: card, order: self.discard.discard_cards.size + 1)

    # remove card from deck
    DeckCard.destroy_by(card: card)
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

  def create_deck
    
  end

  def self.generate_code
    ('A'..'Z').to_a.sample(4).join
  end

  def can_play?(played_card, dis_card)
    VALUE_MAP[played_card.value] >= VALUE_MAP[dis_card.value]
  end
  
end
