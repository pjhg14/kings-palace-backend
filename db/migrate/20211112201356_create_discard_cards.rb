class CreateDiscardCards < ActiveRecord::Migration[6.1]
  def change
    create_table :discard_cards do |t|
      t.belongs_to :discard, null: false, foreign_key: true
      t.belongs_to :card, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
