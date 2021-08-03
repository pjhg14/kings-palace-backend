class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :game_id, :is_host, :has_won

  belongs_to :user
  has_many :moves
end
