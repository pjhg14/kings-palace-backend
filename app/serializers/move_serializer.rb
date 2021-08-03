class MoveSerializer < ActiveModel::Serializer
  attributes :id, :game_id, :player_id, :data, :turn_made
end
