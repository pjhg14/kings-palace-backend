class MovesController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    move = Move.new(permit_params.merge({turn_made: game.turn}))

    if move.valid?
      move.save
      # progress game logic
      player = game.current_player
      action = params[:data]
      #   get card(s) placed by current player
      out_counter = 0
      action.placed_cards.each do |card|
        reset = game.play_card(card, action.from)
        out_counter += 1
      end

      if reset
        # last player goes again
        GameChannel.broadcast_to(game, game)

        render json: {message: "Go again"}
        # return # might be unneeded?
      end

      # add card(s) to discard pile
      # if player.hand.length < 3 & deck is not empty, draw cards until hand.length = 3
      if !game.deck.empty?
        while player.hand.length < 3
          game.pickup()
        end
      end
      
      # check if player has won (has no cards left)
      if player.hand.empty? && player.table[1].empty? && player.table[0].empty?
        player.has_won = true
        game.is_done = true

        if !game.is_solo_game
          player.user.wins += 1
        end
        
      else
        # iterate players
        game.iterate_players
      end
      
      GameChannel.broadcast_to(game, game)

      # Hard to read but basically this (if 3 7's were played): "player played 3 7's"
      # render json: {
      #   message: (
      #     "#{player.username} " + 
      #     "played " +
      #     out_counter > 1 ? "#{out_counter} " : "a " + 
      #     "#{action.placed_cards.sample.value}" + 
      #     out_counter > 1 ? "'s" : ""
      #   )
      # }
      render json: game

    else
      render json: {error: "Error processing move (coder handle plz!!!)"}
    end

  end
  
  private

  def broadcast_game_state
    # broadcast the current state of game to the channel the particular game is hosted on
    GameChannel.broadcast_to(game, game)
  end
  
  def permit_params
    params.require(:move).permit(:game_id, :player_id, :data)
  end
  
end
