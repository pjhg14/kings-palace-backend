class CreateMoves < ActiveRecord::Migration[6.1]
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.integer :player_id
      t.jsonb :data
      t.integer :turn_made

      t.timestamps
    end
  end
end
