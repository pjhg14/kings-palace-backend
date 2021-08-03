class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream specific game
    game = Game.find(params[:id])
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
