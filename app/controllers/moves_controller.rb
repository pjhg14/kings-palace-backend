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
      action.placed_cards.each do |card|
        game.play_card(card, action.from)
      end

      #   add card(s) to discard pile
      #   if player.hand.length < 3 & deck is not empty, draw cards until hand.length = 3
      if !game.deck.empty?
        while player.hand.length < 3
          game.pickup()
        end
      end
      
      # check if player has won (has no cards left)
      if player.hand.empty? && player.table[1].empty? && player.table[0].empty?
        player.has_won = true
        if !game.is_solo_game
          player.user.wins += 1
        end
        
      else
        # iterate players
        game.iterate_players
      end
      
      GameChannel.broadcast_to(game, move)

      render json: game

    else
      render json: {error: "Error processing move (coder handle plz!!!)"}
    end

  end

  private

  def permit_params
    params.require(:move).permit(:game_id, :player_id, :data)
  end
  
end
