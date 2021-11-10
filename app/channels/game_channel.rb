class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream specific game
    @game = Game.find(params[:id])
    stream_for @game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    player = Player.find(params[:player_id])
    player.destroy

    if @game.players.empty
      stop_stream_for @game
      game.destroy
    end
    
  end
end
