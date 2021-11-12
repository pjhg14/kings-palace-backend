class GamesController < ApplicationController
  before_action :logged_in?

  def show
    game = Game.find_by(room_code: params[:room_code])

    render json: game
  end

  def create
    builder = {
      room_code: Game.generate_code,
      turn: 1,
      can_join: true,
      is_done: false
    }

    game = Game.create!(permit_params.merge(builder))
    
    # init game
    game.init
      
    # add current user as host player
    player = Player.create(user: @user, game: game, is_ai: false, is_host: true, has_won: false)

    if params[:is_solo_game]
      ai_player = Player.create(user: @user, game: game, is_ai: true, is_host: false, has_won: false)

      game.start
    end
    
    render json: game

  rescue
    render json: {error: "Cannot create game , please try again later"}
  end

  def join
    game = game.find_by(room_code: params[:room_code])

    raise ArguementError.new("Game does not exist, try again") unless game

    if game.players.length >= 4
      raise ArguementError.new("This game is full")
    end
    
    raise ArguementError.new("This game has already started, please choose another one") unless game.can_join

    # allow join
    player = Player.create(user: user, game: game, is_ai: false, is_host: false, has_won: false)

    broadcast_game_state

    render json: game
    
  rescue => e
    # send error code
    render json: {error: e.message}
  end
  
  # Run start after connections are established
  def start
    game = game.find(params[:id])
    host_player = game.players.find_by(is_host: true)

    if host_player.username == @user.username
      game.start

      broadcast_game_state

      if game.is_solo_game
        render json: game
      else
        render json: {message: "Game started"}
      end
    else
      render json: {error: "Only host can start game"}
    end
    
  end

  def leave
    game = Game.find(params[:id])

    game.destroy

    render json: {message: "Game deleted"}

  rescue
    render json: {error: "something went wrong"}
  end
  

  def penalize
    game = Game.find(params[:game_id])
    player = game.current_player

    game.penalty

    broadcast_game_state

    if game.is_solo_game
      render json: game
    else
      render json: {message: "#{player.username} was penalized"}
    end
  end

  private

  def broadcast_game_state
    # broadcast the current state of game to the channel the particular game is hosted on
    GameChannel.broadcast_to(game, game)
  end
  
  def permit_params
    params.require(:game).permit(:is_solo_game)
  end
  
end
