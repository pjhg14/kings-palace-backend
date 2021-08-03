class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :game_id
      t.boolean :is_ai
      t.boolean :is_host
      t.boolean :has_won

      t.timestamps
    end
  end
end
