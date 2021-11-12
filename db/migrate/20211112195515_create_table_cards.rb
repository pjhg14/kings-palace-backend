class CreateTableCards < ActiveRecord::Migration[6.1]
  def change
    create_table :table_cards do |t|
      t.belongs_to :table, null: false, foreign_key: true
      t.belongs_to :card, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
