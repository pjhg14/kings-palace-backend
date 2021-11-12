class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :room_code
      t.integer :turns
      t.boolean :started
      t.boolean :swap_phase
      t.boolean :main_phase
      t.boolean :solo_game

      t.timestamps
    end
  end
end
