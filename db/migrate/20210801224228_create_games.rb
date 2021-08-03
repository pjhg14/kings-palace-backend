class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :room_code
      t.integer :turn
      t.boolean :can_join
      t.boolean :is_solo_game
      t.boolean :is_done

      t.timestamps
    end
  end
end
