class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.belongs_to :user, class_name: "user", foreign_key: "user_id"
      t.belongs_to :game, class_name: "game", foreign_key: "game_id"
      t.boolean :is_ai
      t.boolean :is_host
      t.boolean :has_won

      t.timestamps
    end
  end
end
