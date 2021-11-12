class CreateDecks < ActiveRecord::Migration[6.1]
  def change
    create_table :decks do |t|
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
