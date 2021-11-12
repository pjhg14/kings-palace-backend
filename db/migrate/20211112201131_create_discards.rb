class CreateDiscards < ActiveRecord::Migration[6.1]
  def change
    create_table :discards do |t|
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
