# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_12_201356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "suit"
    t.string "value"
    t.string "code"
    t.string "full_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "deck_cards", force: :cascade do |t|
    t.bigint "deck_id", null: false
    t.bigint "card_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_deck_cards_on_card_id"
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_decks_on_game_id"
  end

  create_table "discard_cards", force: :cascade do |t|
    t.bigint "discard_id", null: false
    t.bigint "card_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_discard_cards_on_card_id"
    t.index ["discard_id"], name: "index_discard_cards_on_discard_id"
  end

  create_table "discards", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_discards_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "room_code"
    t.integer "turns"
    t.boolean "started"
    t.boolean "swap_phase"
    t.boolean "main_phase"
    t.boolean "solo_game"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hand_cards", force: :cascade do |t|
    t.bigint "hand_id", null: false
    t.bigint "card_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_hand_cards_on_card_id"
    t.index ["hand_id"], name: "index_hand_cards_on_hand_id"
  end

  create_table "hands", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_hands_on_player_id"
  end

  create_table "moves", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "turn_id", null: false
    t.string "source"
    t.string "action"
    t.string "card_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_moves_on_player_id"
    t.index ["turn_id"], name: "index_moves_on_turn_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.boolean "is_ai"
    t.boolean "is_host"
    t.boolean "has_won"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "table_cards", force: :cascade do |t|
    t.bigint "table_id", null: false
    t.bigint "card_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["card_id"], name: "index_table_cards_on_card_id"
    t.index ["table_id"], name: "index_table_cards_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_tables_on_player_id"
  end

  create_table "turns", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["game_id"], name: "index_turns_on_game_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.integer "wins", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "deck_cards", "cards"
  add_foreign_key "deck_cards", "decks"
  add_foreign_key "decks", "games"
  add_foreign_key "discard_cards", "cards"
  add_foreign_key "discard_cards", "discards"
  add_foreign_key "discards", "games"
  add_foreign_key "hand_cards", "cards"
  add_foreign_key "hand_cards", "hands"
  add_foreign_key "hands", "players"
  add_foreign_key "moves", "players"
  add_foreign_key "moves", "turns"
  add_foreign_key "players", "games"
  add_foreign_key "players", "users"
  add_foreign_key "table_cards", "cards"
  add_foreign_key "table_cards", "tables"
  add_foreign_key "tables", "players"
  add_foreign_key "turns", "games"
end
