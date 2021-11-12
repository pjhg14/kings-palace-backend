class MoveSerializer < ActiveModel::Serializer
  attributes :id, :target, :action, :card_code
  has_one :player
  has_one :turn
end
