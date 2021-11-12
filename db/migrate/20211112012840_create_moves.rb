class CreateMoves < ActiveRecord::Migration[6.1]
  def change
    create_table :moves do |t|
      t.belongs_to :player, null: false, foreign_key: true
      t.belongs_to :turn, null: false, foreign_key: true
      t.string :source
      t.string :action
      t.string :card_code

      t.timestamps
    end
  end
end
