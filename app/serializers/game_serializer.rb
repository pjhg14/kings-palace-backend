class GameSerializer < ActiveModel::Serializer
  attributes :id, :room_code, :turn, :can_join, :is_solo_game, :room_code, :deck, :discard, :current_player

  has_many :players
end
