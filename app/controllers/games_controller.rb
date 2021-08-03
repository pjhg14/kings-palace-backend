class GamesController < ApplicationController
  before_action :logged_in?

  def create
    builder = {
      room_code: params[:is_solo_game] ? Game.generate_code : null,
      turn: 1,
      can_join: false,
      is_solo_game: params[:is_solo_game]
      # is_solo_game: params[:is_solo_game] ? true : false
    }

    game = Game.create!(builder)
    
    # init game
    game.init
      
    # add current user as host player
    player = Player.create(user: @user, game: game, is_ai: false, is_host: true, has_won: false)

    if params[:is_solo_game]
      ai_player = Player.create(user: @user, game: game, is_ai: true, is_host: false, has_won: false)
    end
    
    render json: game

  rescue
    render json: {error: "Cannot create game , please try again later"}
  end

  def join
    game = game.find_by(room_code: params[:room_code])

    if game.players.length >= 4
      raise ArguementError.new("This game is full")
    end
    
    if !game.can_join
      raise ArguementError.new("This game has already started, please choose another one")
    end

    # allow join
    player = Player.create(user: user, game: game, is_ai: false, is_host: false, has_won: false)

    GameChannel.broadcast_to(game, player)

    render json: {message: "Game joined"}
    
  rescue => e
    # send error code
    render json: {error: e.message}
  end
  
  # Run start after connections are established
  def start
    game = game.find(params[:id])
    host_player = game.players.find_by(is_host: true)

    if host_player.email == @user
      game.start
      game.can_join = false

      render json: {message: "Game started"}
    else
      render json: {error: "Only host can start game"}
    end
    
  end
  
end
