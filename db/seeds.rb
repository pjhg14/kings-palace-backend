# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Card construction: --------------------------------------------------------------------------/
SUITS = ["Spade", "Club", "Heart","Diamond"]
VALUES = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "0", "J", "Q", "K"]
VALUE_MAP ={
  "2": 99,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "10": 99,
  "J": 11,
  "K": 12,
  "Q": 13,
  "A": 14,
}

SUITS.each do |suit|
  VALUES.each do |value| 
    case value
    when "A"
      full_value = "Ace"
    when "0"
      full_value = "10"
    when "J"
      full_value = "Jack"
    when "Q"
      full_value = "Queen"
    when "K"
      full_value = "King"
    else
      full_value = value
    end

      # Return card hash
      Card.create(suit: suit, value: value, code: suit[0] + value, full_value: full_value)
    end
  end
# ----------------------------------------------------------------------------------------------/