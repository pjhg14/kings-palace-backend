class TurnsController < ApplicationController
  def create
    turn = Turn.new(turn_params)

    # validate moves
    if validate_moves(params[:moves])
      params[:moves].each {|move| move.create(move_params)}

    else
      render json: { error: "Error processing turn; Invalid Move" }
      
    end

    turn.save

    game = turn.game
    moves = turn.moves

    # Process turn
    moves.each do |move|
      # process move
    end
      

    if game.is_solo_game
      # Ai turn and changes
    else
      # broadcast turn to all players
    end
      
    render json: turn
  end

  private

  def turn_params
    params.require(:turn).permit()
  end
  
  def move_params
    params.require(:move).permit()
  end

  def validate_moves(moves)
    # guard clause
    return false if !moves || moves.empty?

    moves.all? do |move|
      move = move.new(move_params)

      move.valid?
    end
    
  end
  
end
