class GameSerializer < ActiveModel::Serializer
  attributes :id, :turns, :room_code

  has_many :players
end
