class CreateDeckCards < ActiveRecord::Migration[6.1]
  def change
    create_table :deck_cards do |t|
      t.belongs_to :deck, null: false, foreign_key: true
      t.belongs_to :card, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
