class CreateHands < ActiveRecord::Migration[6.1]
  def change
    create_table :hands do |t|
      t.belongs_to :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
