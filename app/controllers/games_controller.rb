class GamesController < ApplicationController
  before_action :logged_in?

  def show
    game = Game.find_by(room_code: params[:room_code])

    render json: game
  end

  def create
    builder = {
      room_code: params[:is_solo_game] ? Game.generate_code : null,
      turn: 1,
      can_join: true,
      is_solo_game: params[:is_solo_game],
      is_done: false
    }

    game = Game.create!(builder)
    
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

      render json: {message: "Game started"}
    else
      render json: {error: "Only host can start game"}
    end
    
  end

  private

  def broadcast_game_state
    # broadcast the current state of game to the channel the particular game is hosted on
    GameChannel.broadcast_to(game, game)
  end
  
  
end
