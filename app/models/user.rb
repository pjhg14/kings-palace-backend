class User < ApplicationRecord
  has_secure_password

  has_many :players, dependant: destroy_all

  validates :username, presence: true, uniqueness: true
end
